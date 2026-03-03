/// Data Access Object untuk tabel `detail_konsumsi_siklus`.
///
/// Mencatat detail FIFO — berapa saldo dari siklus mana
/// yang dikonsumsi oleh setiap transaksi.
library;

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/detail_konsumsi_siklus_table.dart';

part 'detail_konsumsi_dao.g.dart';

/// DAO detail konsumsi — tracking FIFO per transaksi.
@DriftAccessor(tables: [DetailKonsumsiSiklusTable])
class DetailKonsumsiDao extends DatabaseAccessor<AppDatabase>
    with _$DetailKonsumsiDaoMixin {
  DetailKonsumsiDao(super.db);

  // ── CREATE ──────────────────────────────────────────────

  /// Catat konsumsi saldo dari siklus tertentu.
  Future<int> tambahKonsumsi(DetailKonsumsiSiklusTableCompanion entry) {
    return into(detailKonsumsiSiklusTable).insert(entry);
  }

  /// Batch insert konsumsi (untuk satu transaksi yang melibatkan beberapa siklus).
  Future<void> tambahKonsumsiMulti(
    List<DetailKonsumsiSiklusTableCompanion> entries,
  ) async {
    await batch((b) {
      b.insertAll(detailKonsumsiSiklusTable, entries);
    });
  }

  // ── READ ────────────────────────────────────────────────

  /// Ambil detail konsumsi berdasarkan ID transaksi.
  Future<List<DetailKonsumsiSiklus>> ambilKonsumsiByTransaksi(int idTransaksi) {
    return (select(
      detailKonsumsiSiklusTable,
    )..where((t) => t.idTransaksi.equals(idTransaksi))).get();
  }

  /// Ambil detail konsumsi berdasarkan ID siklus.
  Future<List<DetailKonsumsiSiklus>> ambilKonsumsiBySiklus(int idSiklus) {
    return (select(
      detailKonsumsiSiklusTable,
    )..where((t) => t.idSiklus.equals(idSiklus))).get();
  }

  /// Hitung total saldo yang sudah dikonsumsi dari siklus tertentu.
  Future<int> totalKonsumsiDariSiklus(int idSiklus) async {
    final result =
        await (selectOnly(detailKonsumsiSiklusTable)
              ..addColumns([detailKonsumsiSiklusTable.jumlahDikonsumsi.sum()])
              ..where(detailKonsumsiSiklusTable.idSiklus.equals(idSiklus)))
            .getSingle();
    return result.read(detailKonsumsiSiklusTable.jumlahDikonsumsi.sum()) ?? 0;
  }

  // ── DELETE ──────────────────────────────────────────────

  /// Hapus semua konsumsi dari transaksi tertentu (untuk rollback FIFO).
  Future<int> hapusKonsumsiByTransaksi(int idTransaksi) {
    return (delete(
      detailKonsumsiSiklusTable,
    )..where((t) => t.idTransaksi.equals(idTransaksi))).go();
  }
}
