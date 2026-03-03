/// FIFO Engine — logika inti pengelolaan saldo siklus.
///
/// Mengimplementasikan metode First-In-First-Out untuk
/// mengkonsumsi saldo dari siklus deposit terlama terlebih dahulu.
/// Semua operasi bersifat atomik (database transaction).
library;

import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import 'fifo_result.dart';

/// Engine FIFO untuk konsumsi saldo siklus.
///
/// Prinsip kerja:
/// 1. Ambil semua siklus aktif, urut dari tanggal terlama (ASC)
/// 2. Iterasi dari siklus terlama, kurangi saldo_sisa
/// 3. Jika saldo siklus habis, tandai 'selesai', lanjut ke berikutnya
/// 4. Catat setiap konsumsi ke detail_konsumsi_siklus
///
/// Semua operasi dilakukan dalam satu database transaction
/// untuk menjamin konsistensi data.
class FifoEngine {
  final AppDatabase _db;

  FifoEngine(this._db);

  /// Konsumsi saldo sebesar [jumlah] dari siklus aktif (FIFO).
  ///
  /// Mengembalikan [FifoResult] yang berisi detail konsumsi per siklus.
  ///
  /// Throws [InsufficientBalanceException] jika saldo tidak cukup.
  /// Throws [NoActiveCycleException] jika tidak ada siklus aktif.
  Future<FifoResult> konsumsiSaldo({
    required int jumlah,
    required int idTransaksi,
  }) async {
    return await _db.transaction(() async {
      // 1. Ambil siklus aktif, urut terlama dulu
      final siklusAktif =
          await (_db.select(_db.siklusTable)
                ..where((t) => t.status.equals('aktif'))
                ..orderBy([(t) => OrderingTerm.asc(t.tanggalMulai)]))
              .get();

      if (siklusAktif.isEmpty) {
        throw NoActiveCycleException(
          'Tidak ada siklus aktif. Tambahkan siklus baru terlebih dahulu.',
        );
      }

      // 2. Hitung total saldo tersedia
      final totalSaldo = siklusAktif.fold<int>(
        0,
        (sum, s) => sum + s.saldoSisa,
      );

      if (totalSaldo < jumlah) {
        throw InsufficientBalanceException(
          'Saldo internal tidak cukup. '
          'Dibutuhkan: $jumlah, Tersedia: $totalSaldo',
          dibutuhkan: jumlah,
          tersedia: totalSaldo,
        );
      }

      // 3. Iterasi FIFO — konsumsi dari siklus terlama
      int sisaKonsumsi = jumlah;
      final detailKonsumsi = <DetailKonsumsiEntry>[];

      for (final siklus in siklusAktif) {
        if (sisaKonsumsi <= 0) break;

        // Tentukan berapa yang bisa diambil dari siklus ini
        final diambil = sisaKonsumsi <= siklus.saldoSisa
            ? sisaKonsumsi
            : siklus.saldoSisa;

        final saldoBaru = siklus.saldoSisa - diambil;

        // 4. Update saldo_sisa siklus
        await (_db.update(_db.siklusTable)
              ..where((t) => t.id.equals(siklus.id)))
            .write(SiklusTableCompanion(saldoSisa: Value(saldoBaru)));

        // 5. Jika saldo habis, tandai selesai
        if (saldoBaru == 0) {
          await (_db.update(
            _db.siklusTable,
          )..where((t) => t.id.equals(siklus.id))).write(
            SiklusTableCompanion(
              status: const Value('selesai'),
              tanggalSelesai: Value(DateTime.now()),
            ),
          );
        }

        // 6. Catat detail konsumsi
        await _db
            .into(_db.detailKonsumsiSiklusTable)
            .insert(
              DetailKonsumsiSiklusTableCompanion.insert(
                idTransaksi: idTransaksi,
                idSiklus: siklus.id,
                jumlahDikonsumsi: diambil,
              ),
            );

        detailKonsumsi.add(
          DetailKonsumsiEntry(
            idSiklus: siklus.id,
            namaSiklus: siklus.namaSiklus,
            jumlahDikonsumsi: diambil,
            saldoSisaSiklus: saldoBaru,
          ),
        );

        sisaKonsumsi -= diambil;
      }

      return FifoResult(
        totalDikonsumsi: jumlah,
        detailKonsumsi: detailKonsumsi,
      );
    });
  }

  /// Rollback konsumsi FIFO — kembalikan saldo ke siklus semula.
  ///
  /// Digunakan saat transaksi dibatalkan atau gagal dikirim ke Digiflazz.
  Future<void> rollbackKonsumsi(int idTransaksi) async {
    await _db.transaction(() async {
      // 1. Ambil detail konsumsi yang perlu di-rollback
      final details = await (_db.select(
        _db.detailKonsumsiSiklusTable,
      )..where((t) => t.idTransaksi.equals(idTransaksi))).get();

      for (final detail in details) {
        // 2. Ambil siklus saat ini
        final siklus = await (_db.select(
          _db.siklusTable,
        )..where((t) => t.id.equals(detail.idSiklus))).getSingleOrNull();

        if (siklus != null) {
          final saldoBaru = siklus.saldoSisa + detail.jumlahDikonsumsi;

          // 3. Kembalikan saldo
          await (_db.update(_db.siklusTable)
                ..where((t) => t.id.equals(detail.idSiklus)))
              .write(SiklusTableCompanion(saldoSisa: Value(saldoBaru)));

          // 4. Jika siklus tadinya 'selesai', kembalikan ke 'aktif'
          if (siklus.status == 'selesai') {
            await (_db.update(
              _db.siklusTable,
            )..where((t) => t.id.equals(detail.idSiklus))).write(
              const SiklusTableCompanion(
                status: Value('aktif'),
                tanggalSelesai: Value(null),
              ),
            );
          }
        }
      }

      // 5. Hapus detail konsumsi
      await (_db.delete(
        _db.detailKonsumsiSiklusTable,
      )..where((t) => t.idTransaksi.equals(idTransaksi))).go();
    });
  }
}

/// Exception: saldo internal tidak cukup untuk transaksi.
class InsufficientBalanceException implements Exception {
  final String message;
  final int dibutuhkan;
  final int tersedia;

  InsufficientBalanceException(
    this.message, {
    required this.dibutuhkan,
    required this.tersedia,
  });

  @override
  String toString() => 'InsufficientBalanceException: $message';
}

/// Exception: tidak ada siklus aktif.
class NoActiveCycleException implements Exception {
  final String message;

  NoActiveCycleException(this.message);

  @override
  String toString() => 'NoActiveCycleException: $message';
}
