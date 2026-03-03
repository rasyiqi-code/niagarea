/// Definisi tabel `detail_konsumsi_siklus` untuk database Drift.
///
/// Tabel pivot yang mencatat berapa saldo dari siklus
/// mana yang dikonsumsi oleh setiap transaksi.
/// Ini adalah inti dari tracking FIFO.
library;

import 'package:drift/drift.dart';

import 'siklus_table.dart';
import 'transaksi_table.dart';

/// Tabel detail konsumsi siklus — tracking FIFO.
///
/// Ketika satu transaksi memakan saldo dari beberapa siklus,
/// setiap bagian dicatat sebagai satu row di tabel ini.
///
/// Contoh: Transaksi 11.000
/// - Siklus 1 (sisa 3.000): dikonsumsi 3.000
/// - Siklus 2 (sisa 498.000): dikonsumsi 8.000
/// → 2 rows di tabel ini.
@DataClassName('DetailKonsumsiSiklus')
class DetailKonsumsiSiklusTable extends Table {
  /// ID auto-increment
  IntColumn get id => integer().autoIncrement()();

  /// FK ke transaksi yang mengkonsumsi saldo
  IntColumn get idTransaksi => integer().references(TransaksiTable, #id)();

  /// FK ke siklus yang saldonya dikonsumsi
  IntColumn get idSiklus => integer().references(SiklusTable, #id)();

  /// Jumlah saldo yang dikonsumsi dari siklus ini (dalam Rupiah)
  IntColumn get jumlahDikonsumsi => integer()();

  @override
  String get tableName => 'detail_konsumsi_siklus';
}
