/// Data Access Object untuk tabel `produk`.
///
/// Menyediakan operasi CRUD, search, dan bulk upsert
/// untuk manajemen katalog produk.
library;

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/produk_table.dart';

part 'produk_dao.g.dart';

/// DAO produk — CRUD dan sinkronisasi katalog.
@DriftAccessor(tables: [ProdukTable])
class ProdukDao extends DatabaseAccessor<AppDatabase> with _$ProdukDaoMixin {
  ProdukDao(super.db);

  // ── CREATE ──────────────────────────────────────────────

  /// Tambah produk baru. Mengembalikan ID produk.
  Future<int> tambahProduk(ProdukTableCompanion entry) {
    return into(produkTable).insert(entry);
  }

  /// Bulk upsert produk dari API Digiflazz.
  ///
  /// Insert jika kode_digiflazz belum ada, update jika sudah ada.
  Future<void> upsertProdukBatch(List<ProdukTableCompanion> entries) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(produkTable, entries);
    });
  }

  // ── READ ────────────────────────────────────────────────

  /// Ambil semua produk yang aktif dijual.
  Future<List<Produk>> ambilProdukAktif() {
    return (select(produkTable)
          ..where((t) => t.aktif.equals(true))
          ..orderBy([
            (t) => OrderingTerm.asc(t.kategori),
            (t) => OrderingTerm.asc(t.nama),
          ]))
        .get();
  }

  /// Stream produk aktif (reactive).
  Stream<List<Produk>> watchProdukAktif() {
    return (select(produkTable)
          ..where((t) => t.aktif.equals(true))
          ..orderBy([
            (t) => OrderingTerm.asc(t.kategori),
            (t) => OrderingTerm.asc(t.nama),
          ]))
        .watch();
  }

  /// Ambil semua produk (termasuk non-aktif), untuk halaman sinkronisasi.
  Future<List<Produk>> ambilSemuaProduk() {
    return (select(produkTable)..orderBy([
          (t) => OrderingTerm.asc(t.kategori),
          (t) => OrderingTerm.asc(t.nama),
        ]))
        .get();
  }

  /// Ambil produk berdasarkan kategori.
  Future<List<Produk>> ambilProdukByKategori(String kategori) {
    return (select(produkTable)
          ..where((t) => t.kategori.equals(kategori) & t.aktif.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nama)]))
        .get();
  }

  /// Cari produk berdasarkan nama.
  Future<List<Produk>> cariProduk(String query) {
    return (select(produkTable)
          ..where((t) => t.nama.like('%$query%'))
          ..orderBy([(t) => OrderingTerm.asc(t.nama)]))
        .get();
  }

  /// Ambil satu produk berdasarkan ID.
  Future<Produk?> ambilProdukById(int id) {
    return (select(
      produkTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // ── UPDATE ──────────────────────────────────────────────

  /// Update harga jual produk.
  Future<bool> updateHargaJual(int idProduk, int hargaJualBaru) {
    return (update(produkTable)..where((t) => t.id.equals(idProduk)))
        .write(ProdukTableCompanion(hargaJual: Value(hargaJualBaru)))
        .then((rows) => rows > 0);
  }

  /// Toggle status aktif produk.
  Future<bool> toggleAktif(int idProduk, bool aktif) {
    return (update(produkTable)..where((t) => t.id.equals(idProduk)))
        .write(ProdukTableCompanion(aktif: Value(aktif)))
        .then((rows) => rows > 0);
  }

  /// Update produk secara penuh.
  Future<bool> updateProduk(Produk produk) {
    return (update(produkTable)..where((t) => t.id.equals(produk.id)))
        .write(produk.toCompanion(true))
        .then((rows) => rows > 0);
  }

  // ── DELETE ──────────────────────────────────────────────

  /// Hapus produk berdasarkan ID.
  Future<int> hapusProduk(int idProduk) {
    return (delete(produkTable)..where((t) => t.id.equals(idProduk))).go();
  }
}
