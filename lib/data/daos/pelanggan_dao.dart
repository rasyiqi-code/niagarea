/// Data Access Object untuk tabel `pelanggan`.
///
/// Menyediakan operasi CRUD dan search untuk
/// manajemen data pelanggan.
library;

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/pelanggan_table.dart';

part 'pelanggan_dao.g.dart';

/// DAO pelanggan — CRUD dan pencarian pelanggan.
@DriftAccessor(tables: [PelangganTable])
class PelangganDao extends DatabaseAccessor<AppDatabase>
    with _$PelangganDaoMixin {
  PelangganDao(super.db);

  // ── CREATE ──────────────────────────────────────────────

  /// Tambah pelanggan baru. Mengembalikan ID pelanggan.
  Future<int> tambahPelanggan(PelangganTableCompanion entry) {
    return into(pelangganTable).insert(entry);
  }

  // ── READ ────────────────────────────────────────────────

  /// Ambil semua pelanggan, diurutkan nama ascending.
  Future<List<Pelanggan>> ambilSemuaPelanggan() {
    return (select(
      pelangganTable,
    )..orderBy([(t) => OrderingTerm.asc(t.nama)])).get();
  }

  /// Stream semua pelanggan (reactive).
  Stream<List<Pelanggan>> watchSemuaPelanggan() {
    return (select(
      pelangganTable,
    )..orderBy([(t) => OrderingTerm.asc(t.nama)])).watch();
  }

  /// Cari pelanggan berdasarkan nama atau no HP.
  Future<List<Pelanggan>> cariPelanggan(String query) {
    return (select(pelangganTable)
          ..where((t) => t.nama.like('%$query%') | t.noHp.like('%$query%'))
          ..orderBy([(t) => OrderingTerm.asc(t.nama)]))
        .get();
  }

  /// Ambil satu pelanggan berdasarkan ID.
  Future<Pelanggan?> ambilPelangganById(int id) {
    return (select(
      pelangganTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // ── UPDATE ──────────────────────────────────────────────

  /// Update data pelanggan.
  Future<bool> updatePelanggan(Pelanggan pelanggan) {
    return (update(pelangganTable)..where((t) => t.id.equals(pelanggan.id)))
        .write(pelanggan.toCompanion(true))
        .then((rows) => rows > 0);
  }

  // ── DELETE ──────────────────────────────────────────────

  /// Hapus pelanggan berdasarkan ID.
  /// Catatan: Pelanggan "Umum" (id=1) tidak boleh dihapus.
  Future<int> hapusPelanggan(int idPelanggan) {
    if (idPelanggan == 1) return Future.value(0); // Proteksi
    return (delete(
      pelangganTable,
    )..where((t) => t.id.equals(idPelanggan))).go();
  }
}
