/// Data Access Object untuk tabel `transaksi`.
///
/// Menyediakan operasi CRUD dan query riwayat
/// transaksi dengan join ke pelanggan & produk.
library;

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/pelanggan_table.dart';
import '../database/tables/transaksi_table.dart';

part 'transaksi_dao.g.dart';

/// Data class untuk transaksi dengan info pelanggan (JOIN).
class TransaksiDenganPelanggan {
  final Transaksi transaksi;
  final Pelanggan? pelanggan;

  TransaksiDenganPelanggan({required this.transaksi, this.pelanggan});
}

/// DAO transaksi — CRUD dan query riwayat.
@DriftAccessor(tables: [TransaksiTable, PelangganTable])
class TransaksiDao extends DatabaseAccessor<AppDatabase>
    with _$TransaksiDaoMixin {
  TransaksiDao(super.db);

  // ── CREATE ──────────────────────────────────────────────

  /// Tambah transaksi baru. Mengembalikan ID transaksi.
  Future<int> tambahTransaksi(TransaksiTableCompanion entry) {
    return into(transaksiTable).insert(entry);
  }

  // ── READ ────────────────────────────────────────────────

  /// Ambil N transaksi terakhir dengan info pelanggan.
  Future<List<TransaksiDenganPelanggan>> ambilTransaksiTerakhir({
    int limit = 10,
  }) async {
    final query =
        select(transaksiTable).join([
            leftOuterJoin(
              pelangganTable,
              pelangganTable.id.equalsExp(transaksiTable.idPelanggan),
            ),
          ])
          ..orderBy([OrderingTerm.desc(transaksiTable.createdAt)])
          ..limit(limit);

    final rows = await query.get();
    return rows.map((row) {
      return TransaksiDenganPelanggan(
        transaksi: row.readTable(transaksiTable),
        pelanggan: row.readTableOrNull(pelangganTable),
      );
    }).toList();
  }

  /// Stream transaksi terakhir (reactive).
  Stream<List<TransaksiDenganPelanggan>> watchTransaksiTerakhir({
    int limit = 10,
  }) {
    final query =
        select(transaksiTable).join([
            leftOuterJoin(
              pelangganTable,
              pelangganTable.id.equalsExp(transaksiTable.idPelanggan),
            ),
          ])
          ..orderBy([OrderingTerm.desc(transaksiTable.createdAt)])
          ..limit(limit);

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransaksiDenganPelanggan(
          transaksi: row.readTable(transaksiTable),
          pelanggan: row.readTableOrNull(pelangganTable),
        );
      }).toList();
    });
  }

  /// Ambil transaksi berdasarkan rentang tanggal.
  Future<List<TransaksiDenganPelanggan>> ambilTransaksiByTanggal(
    DateTime dari,
    DateTime sampai,
  ) async {
    final query =
        select(transaksiTable).join([
            leftOuterJoin(
              pelangganTable,
              pelangganTable.id.equalsExp(transaksiTable.idPelanggan),
            ),
          ])
          ..where(transaksiTable.createdAt.isBetweenValues(dari, sampai))
          ..orderBy([OrderingTerm.desc(transaksiTable.createdAt)]);

    final rows = await query.get();
    return rows.map((row) {
      return TransaksiDenganPelanggan(
        transaksi: row.readTable(transaksiTable),
        pelanggan: row.readTableOrNull(pelangganTable),
      );
    }).toList();
  }

  /// Hitung total profit dalam rentang tanggal.
  Future<int> hitungTotalProfit(DateTime dari, DateTime sampai) async {
    final result =
        await (selectOnly(transaksiTable)
              ..addColumns([transaksiTable.profit.sum()])
              ..where(transaksiTable.createdAt.isBetweenValues(dari, sampai)))
            .getSingle();
    return result.read(transaksiTable.profit.sum()) ?? 0;
  }

  /// Hitung total piutang (sum harga_jual di mana status_bayar = 'utang').
  Future<int> hitungTotalPiutang() async {
    final result =
        await (selectOnly(transaksiTable)
              ..addColumns([transaksiTable.hargaJual.sum()])
              ..where(transaksiTable.statusBayar.equals('utang')))
            .getSingle();
    return result.read(transaksiTable.hargaJual.sum()) ?? 0;
  }

  /// Hitung jumlah transaksi di suatu periode.
  Future<int> hitungJumlahTransaksi(DateTime dari, DateTime sampai) async {
    final result =
        await (selectOnly(transaksiTable)
              ..addColumns([transaksiTable.id.count()])
              ..where(transaksiTable.createdAt.isBetweenValues(dari, sampai)))
            .getSingle();
    return result.read(transaksiTable.id.count()) ?? 0;
  }

  // ── UPDATE ──────────────────────────────────────────────

  /// Update status bayar transaksi (lunas / utang).
  Future<bool> updateStatusBayar(int idTransaksi, String statusBaru) {
    return (update(transaksiTable)..where((t) => t.id.equals(idTransaksi)))
        .write(TransaksiTableCompanion(statusBayar: Value(statusBaru)))
        .then((rows) => rows > 0);
  }

  /// Update status kirim transaksi.
  Future<bool> updateStatusKirim(int idTransaksi, String statusBaru) {
    return (update(transaksiTable)..where((t) => t.id.equals(idTransaksi)))
        .write(TransaksiTableCompanion(statusKirim: Value(statusBaru)))
        .then((rows) => rows > 0);
  }

  // ── DELETE ──────────────────────────────────────────────

  /// Hapus transaksi berdasarkan ID.
  Future<int> hapusTransaksi(int idTransaksi) {
    return (delete(
      transaksiTable,
    )..where((t) => t.id.equals(idTransaksi))).go();
  }
}
