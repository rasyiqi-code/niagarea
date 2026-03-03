/// Data Access Object untuk tabel `siklus`.
///
/// Menyediakan operasi CRUD dan query khusus
/// untuk manajemen siklus deposit.
library;

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/siklus_table.dart';

part 'siklus_dao.g.dart';

/// DAO siklus — CRUD dan query siklus deposit.
@DriftAccessor(tables: [SiklusTable])
class SiklusDao extends DatabaseAccessor<AppDatabase> with _$SiklusDaoMixin {
  SiklusDao(super.db);

  // ── CREATE ──────────────────────────────────────────────

  /// Tambah siklus baru. Mengembalikan ID siklus yang dibuat.
  Future<int> tambahSiklus(SiklusTableCompanion entry) {
    return into(siklusTable).insert(entry);
  }

  // ── READ ────────────────────────────────────────────────

  /// Ambil semua siklus, diurutkan tanggal mulai descending (terbaru dulu).
  Future<List<Siklus>> ambilSemuaSiklus() {
    return (select(
      siklusTable,
    )..orderBy([(t) => OrderingTerm.desc(t.tanggalMulai)])).get();
  }

  /// Ambil siklus aktif saja, diurutkan tanggal mulai ascending (terlama dulu).
  /// Urutan ASC penting untuk logika FIFO.
  Future<List<Siklus>> ambilSiklusAktif() {
    return (select(siklusTable)
          ..where((t) => t.status.equals('aktif'))
          ..orderBy([(t) => OrderingTerm.asc(t.tanggalMulai)]))
        .get();
  }

  /// Stream siklus aktif (reactive) untuk UI.
  Stream<List<Siklus>> watchSiklusAktif() {
    return (select(siklusTable)
          ..where((t) => t.status.equals('aktif'))
          ..orderBy([(t) => OrderingTerm.asc(t.tanggalMulai)]))
        .watch();
  }

  /// Ambil satu siklus berdasarkan ID.
  Future<Siklus?> ambilSiklusById(int id) {
    return (select(
      siklusTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Hitung total saldo sisa dari semua siklus aktif.
  Future<int> hitungTotalSaldoInternal() async {
    final siklusAktifList = await ambilSiklusAktif();
    return siklusAktifList.fold<int>(0, (sum, s) => sum + s.saldoSisa);
  }

  /// Stream total saldo internal (reactive).
  Stream<int> watchTotalSaldoInternal() {
    return watchSiklusAktif().map(
      (list) => list.fold<int>(0, (sum, s) => sum + s.saldoSisa),
    );
  }

  // ── UPDATE ──────────────────────────────────────────────

  /// Update saldo sisa siklus (digunakan oleh FIFO engine).
  Future<bool> updateSaldoSisa(int idSiklus, int saldoBaru) {
    return (update(siklusTable)..where((t) => t.id.equals(idSiklus)))
        .write(SiklusTableCompanion(saldoSisa: Value(saldoBaru)))
        .then((rows) => rows > 0);
  }

  /// Tandai siklus sebagai selesai (saldo habis).
  Future<bool> tandaiSelesai(int idSiklus) {
    return (update(siklusTable)..where((t) => t.id.equals(idSiklus)))
        .write(
          SiklusTableCompanion(
            status: const Value('selesai'),
            tanggalSelesai: Value(DateTime.now()),
          ),
        )
        .then((rows) => rows > 0);
  }

  // ── DELETE ──────────────────────────────────────────────

  /// Hapus siklus berdasarkan ID (hanya jika belum ada transaksi).
  Future<int> hapusSiklus(int idSiklus) {
    return (delete(siklusTable)..where((t) => t.id.equals(idSiklus))).go();
  }
}
