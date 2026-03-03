/// Data Access Object untuk tabel `antrian_digiflazz`.
///
/// Mengelola antrian transaksi offline yang perlu
/// dikirim ke API Digiflazz saat ada koneksi.
library;

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/antrian_digiflazz_table.dart';

part 'antrian_dao.g.dart';

/// DAO antrian Digiflazz — CRUD antrian offline.
@DriftAccessor(tables: [AntrianDigiflazzTable])
class AntrianDao extends DatabaseAccessor<AppDatabase> with _$AntrianDaoMixin {
  AntrianDao(super.db);

  // ── CREATE ──────────────────────────────────────────────

  /// Tambah item ke antrian. Mengembalikan ID antrian.
  Future<int> tambahKeAntrian(AntrianDigiflazzTableCompanion entry) {
    return into(antrianDigiflazzTable).insert(entry);
  }

  // ── READ ────────────────────────────────────────────────

  /// Ambil semua antrian pending (belum dikirim).
  Future<List<AntrianDigiflazz>> ambilPending() {
    return (select(antrianDigiflazzTable)
          ..where((t) => t.statusKirim.equals('pending'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Ambil semua item antrian (semua status).
  Future<List<AntrianDigiflazz>> ambilSemuaAntrian() {
    return (select(
      antrianDigiflazzTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  /// Stream antrian (reactive) untuk UI.
  Stream<List<AntrianDigiflazz>> watchAntrian() {
    return (select(
      antrianDigiflazzTable,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  /// Hitung jumlah antrian pending.
  Future<int> hitungPending() async {
    final result =
        await (selectOnly(antrianDigiflazzTable)
              ..addColumns([antrianDigiflazzTable.id.count()])
              ..where(antrianDigiflazzTable.statusKirim.equals('pending')))
            .getSingle();
    return result.read(antrianDigiflazzTable.id.count()) ?? 0;
  }

  // ── UPDATE ──────────────────────────────────────────────

  /// Update status kirim antrian.
  Future<bool> updateStatusKirim(
    int idAntrian,
    String statusBaru,
    String responseApi,
  ) {
    return (update(antrianDigiflazzTable)..where((t) => t.id.equals(idAntrian)))
        .write(
          AntrianDigiflazzTableCompanion(
            statusKirim: Value(statusBaru),
            responseApi: Value(responseApi),
          ),
        )
        .then((rows) => rows > 0);
  }

  // ── DELETE ──────────────────────────────────────────────

  /// Hapus item antrian berdasarkan ID.
  Future<int> hapusAntrian(int idAntrian) {
    return (delete(
      antrianDigiflazzTable,
    )..where((t) => t.id.equals(idAntrian))).go();
  }

  /// Hapus semua antrian yang sudah sukses (pembersihan).
  Future<int> hapusAntrianSukses() {
    return (delete(
      antrianDigiflazzTable,
    )..where((t) => t.statusKirim.equals('sukses'))).go();
  }
}
