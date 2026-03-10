/// Provider transaksi — state management operasi jual.
///
/// Menyediakan stream transaksi terakhir, statistik,
/// dan notifier untuk membuat transaksi baru.
/// Terintegrasi dengan antrian Digiflazz untuk pengiriman otomatis.
library;

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/daos/transaksi_dao.dart';
import '../../data/database/app_database.dart';
import '../../domain/fifo/fifo_engine.dart';
import '../../services/digiflazz/transaction_queue_service.dart';
import 'core_providers.dart';
import 'digiflazz_provider.dart';

/// Stream provider 10 transaksi terakhir (reactive).
final transaksiTerakhirProvider = StreamProvider<List<TransaksiDenganInfo>>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  return db.transaksiDao.watchTransaksiTerakhir(limit: 10);
});

/// Future provider total piutang.
final totalPiutangProvider = FutureProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return db.transaksiDao.hitungTotalPiutang();
});

/// Future provider total profit hari ini.
final profitHariIniProvider = FutureProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final awalHari = DateTime(now.year, now.month, now.day);
  final akhirHari = awalHari.add(const Duration(days: 1));
  return db.transaksiDao.hitungTotalProfit(awalHari, akhirHari);
});

/// Notifier untuk membuat dan mengelola transaksi.
///
/// Alur transaksi baru:
/// 1. Insert transaksi ke database
/// 2. FIFO Engine konsumsi saldo dari siklus terlama
/// 3. (Opsional) Tambahkan ke antrian Digiflazz + coba kirim
/// 4. Jika FIFO gagal, hapus transaksi (rollback)
class TransaksiNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _db;
  final FifoEngine _fifoEngine;
  final TransactionQueueService? _queueService;

  TransaksiNotifier(this._db, this._fifoEngine, [this._queueService])
    : super(const AsyncValue.data(null));

  /// Buat transaksi baru dengan FIFO + antrian Digiflazz.
  ///
  /// [kodeDigiflazz] — jika diisi, transaksi akan masuk antrian.
  /// Jika kosong atau null, transaksi dicatat manual tanpa API.
  Future<int?> buatTransaksi({
    required int? idPelanggan,
    required int? idProduk,
    required String namaProduk,
    required int hargaBeli,
    required int hargaJual,
    required String statusBayar,
    required int? idKotakUang,
    String tujuan = '',
    String catatan = '',
    String? kodeDigiflazz,
  }) async {
    state = const AsyncValue.loading();
    try {
      final profit = hargaJual - hargaBeli;

      // Tentukan status kirim berdasarkan ada/tidaknya kode Digiflazz
      final statusKirim = (kodeDigiflazz != null && kodeDigiflazz.isNotEmpty)
          ? 'pending'
          : 'manual';

      // 1. Insert transaksi
      final idTransaksi = await _db.transaksiDao.tambahTransaksi(
        TransaksiTableCompanion.insert(
          idPelanggan: Value(idPelanggan),
          idProduk: Value(idProduk),
          namaProduk: Value(namaProduk),
          hargaBeli: hargaBeli,
          hargaJual: hargaJual,
          profit: profit,
          statusBayar: Value(statusBayar),
          statusKirim: Value(statusKirim),
          idKotakUang: Value(idKotakUang),
          tujuan: Value(tujuan),
          catatan: Value(catatan),
        ),
      );

      // 1.1. Update saldo Kotak Uang jika lunas
      if (statusBayar == 'lunas' && idKotakUang != null) {
        await _db.kotakUangDao.updateSaldo(idKotakUang, hargaJual);
      }

      // 2. Konsumsi saldo FIFO
      try {
        await _fifoEngine.konsumsiSaldo(
          jumlah: hargaBeli,
          idTransaksi: idTransaksi,
        );
      } catch (e) {
        // 3. Rollback — hapus transaksi jika FIFO gagal
        await _db.transaksiDao.hapusTransaksi(idTransaksi);
        rethrow;
      }

      // 4. Tambahkan ke antrian Digiflazz (jika ada kode produk)
      if (kodeDigiflazz != null &&
          kodeDigiflazz.isNotEmpty &&
          tujuan.isNotEmpty &&
          _queueService != null) {
        try {
          await _queueService.tambahDanKirim(
            idTransaksi: idTransaksi,
            kodeProduk: kodeDigiflazz,
            tujuan: tujuan,
          );
        } catch (_) {
          // Jika gagal kirim, transaksi tetap tersimpan (antrian pending).
          // User bisa kirim ulang via halaman Antrian.
        }
      }

      state = const AsyncValue.data(null);
      return idTransaksi;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Update status bayar transaksi.
  Future<void> updateStatusBayar(int idTransaksi, String status) async {
    state = const AsyncValue.loading();
    try {
      await _db.transaksiDao.updateStatusBayar(idTransaksi, status);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Batalkan transaksi — rollback FIFO & Saldo Kotak Uang.
  Future<void> batalkanTransaksi(int idTransaksi) async {
    state = const AsyncValue.loading();
    try {
      final trx = await (_db.select(
        _db.transaksiTable,
      )..where((t) => t.id.equals(idTransaksi))).getSingle();

      // Rollback saldo Kotak Uang jika lunas
      if (trx.statusBayar == 'lunas' && trx.idKotakUang != null) {
        await _db.kotakUangDao.updateSaldo(trx.idKotakUang!, -trx.hargaJual);
      }

      await _fifoEngine.rollbackKonsumsi(idTransaksi);
      await _db.transaksiDao.hapusTransaksi(idTransaksi);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider notifier transaksi (dengan integrasi antrian Digiflazz).
final transaksiNotifierProvider =
    StateNotifierProvider<TransaksiNotifier, AsyncValue<void>>((ref) {
      final db = ref.watch(databaseProvider);
      final fifo = ref.watch(fifoEngineProvider);
      final queue = ref.watch(transactionQueueProvider);
      return TransaksiNotifier(db, fifo, queue);
    });
