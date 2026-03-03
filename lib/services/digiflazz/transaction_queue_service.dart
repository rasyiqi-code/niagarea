/// Service antrian transaksi offline untuk Digiflazz.
///
/// Mengelola transaksi yang perlu dikirim ke API Digiflazz.
/// Mendukung mode offline — transaksi dicatat dulu,
/// dikirim saat ada koneksi internet.
library;

import 'package:uuid/uuid.dart';

import '../../data/daos/antrian_dao.dart';
import '../../data/database/app_database.dart';
import '../../domain/fifo/fifo_engine.dart';
import 'digiflazz_client.dart';

/// Hasil pemrosesan antrian transaksi.
class QueueProcessResult {
  /// Jumlah transaksi yang berhasil dikirim
  final int sukses;

  /// Jumlah transaksi yang gagal
  final int gagal;

  /// Jumlah transaksi yang masih pending
  final int pending;

  /// Detail error per transaksi gagal (idAntrian → pesan error)
  final Map<int, String> errors;

  const QueueProcessResult({
    required this.sukses,
    required this.gagal,
    required this.pending,
    this.errors = const {},
  });
}

/// Service antrian transaksi offline → Digiflazz.
///
/// Alur kerja:
/// 1. Transaksi dibuat (FIFO sudah dikonsumsi)
/// 2. Ditambahkan ke antrian dengan status 'pending'
/// 3. Jika online, langsung kirim ke Digiflazz
/// 4. Jika offline, simpan di antrian untuk nanti
/// 5. Saat online, proses semua antrian pending
/// 6. Jika gagal, rollback FIFO saldo
class TransactionQueueService {
  final DigiflazzClient _client;
  final AntrianDao _antrianDao;
  final FifoEngine _fifoEngine;

  /// Generator UUID untuk reference ID unik
  static const _uuid = Uuid();

  TransactionQueueService({
    required DigiflazzClient client,
    required AntrianDao antrianDao,
    required FifoEngine fifoEngine,
  }) : _client = client,
       _antrianDao = antrianDao,
       _fifoEngine = fifoEngine;

  /// Tambahkan transaksi ke antrian dan coba kirim langsung.
  ///
  /// [idTransaksi] — ID transaksi lokal (sudah di-FIFO).
  /// [kodeProduk] — buyer_sku_code dari Digiflazz.
  /// [tujuan] — nomor HP/meter pelanggan.
  ///
  /// Mengembalikan ID antrian yang dibuat.
  Future<int> tambahDanKirim({
    required int idTransaksi,
    required String kodeProduk,
    required String tujuan,
  }) async {
    final refId = _uuid.v4();

    // 1. Insert ke antrian
    final idAntrian = await _antrianDao.tambahKeAntrian(
      AntrianDigiflazzTableCompanion.insert(
        idTransaksi: idTransaksi,
        kodeProduk: kodeProduk,
        tujuan: tujuan,
        refId: refId,
      ),
    );

    // 2. Coba kirim langsung
    try {
      await _kirimSatuTransaksi(
        idAntrian: idAntrian,
        kodeProduk: kodeProduk,
        tujuan: tujuan,
        refId: refId,
        idTransaksi: idTransaksi,
      );
    } on DigiflazzException catch (_) {
      // Gagal kirim — biarkan tetap pending, akan dicoba lagi nanti
      // Error sudah ditangani di _kirimSatuTransaksi
    }

    return idAntrian;
  }

  /// Proses semua antrian pending sekaligus.
  ///
  /// Iterasi semua item pending, kirim satu per satu.
  /// Mengembalikan [QueueProcessResult] berisi statistik.
  Future<QueueProcessResult> prosesSemuaPending() async {
    final pendingList = await _antrianDao.ambilPending();

    if (pendingList.isEmpty) {
      return const QueueProcessResult(sukses: 0, gagal: 0, pending: 0);
    }

    int sukses = 0;
    int gagal = 0;
    final errors = <int, String>{};

    for (final item in pendingList) {
      try {
        await _kirimSatuTransaksi(
          idAntrian: item.id,
          kodeProduk: item.kodeProduk,
          tujuan: item.tujuan,
          refId: item.refId,
          idTransaksi: item.idTransaksi,
        );
        sukses++;
      } catch (e) {
        gagal++;
        errors[item.id] = e.toString();
      }
    }

    // Hitung sisa pending setelah proses
    final sisaPending = await _antrianDao.hitungPending();

    return QueueProcessResult(
      sukses: sukses,
      gagal: gagal,
      pending: sisaPending,
      errors: errors,
    );
  }

  /// Kirim ulang satu item antrian yang gagal/pending.
  ///
  /// Throws [DigiflazzException] jika gagal lagi.
  Future<void> kirimUlang(int idAntrian) async {
    final items = await _antrianDao.ambilSemuaAntrian();
    final item = items.firstWhere(
      (a) => a.id == idAntrian,
      orElse: () => throw StateError('Antrian $idAntrian tidak ditemukan'),
    );

    await _kirimSatuTransaksi(
      idAntrian: item.id,
      kodeProduk: item.kodeProduk,
      tujuan: item.tujuan,
      refId: item.refId,
      idTransaksi: item.idTransaksi,
    );
  }

  /// Kirim satu transaksi ke API Digiflazz.
  ///
  /// Jika berhasil → update status 'sukses'.
  /// Jika gagal → update status 'gagal' + rollback FIFO.
  Future<void> _kirimSatuTransaksi({
    required int idAntrian,
    required String kodeProduk,
    required String tujuan,
    required String refId,
    required int idTransaksi,
  }) async {
    try {
      final response = await _client.kirimTransaksi(
        buyerSkuCode: kodeProduk,
        customerNo: tujuan,
        refId: refId,
      );

      if (response.isSukses) {
        // Sukses — update status antrian
        await _antrianDao.updateStatusKirim(
          idAntrian,
          'sukses',
          response.toString(),
        );
      } else if (response.isPending) {
        // Masih diproses — biarkan pending
        await _antrianDao.updateStatusKirim(
          idAntrian,
          'pending',
          response.toString(),
        );
      } else {
        // Gagal — rollback FIFO saldo
        await _antrianDao.updateStatusKirim(
          idAntrian,
          'gagal',
          response.toString(),
        );
        await _fifoEngine.rollbackKonsumsi(idTransaksi);
      }
    } on DigiflazzException catch (e) {
      // Error koneksi/server — tandai gagal tapi JANGAN rollback FIFO
      // karena bisa jadi transaksi sudah diproses di sisi Digiflazz.
      // Biarkan user memutuskan via "Kirim Ulang".
      if (e.type == DigiflazzErrorType.noInternet ||
          e.type == DigiflazzErrorType.timeout) {
        // Biarkan tetap pending untuk retry otomatis
        rethrow;
      }

      // Error lain (server error, credential salah) → gagal
      await _antrianDao.updateStatusKirim(idAntrian, 'gagal', e.toString());
      rethrow;
    }
  }
}
