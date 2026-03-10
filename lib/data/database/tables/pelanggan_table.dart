/// Definisi tabel `pelanggan` untuk database Drift.
///
/// Menyimpan data pelanggan yang membeli
/// pulsa/token dari reseller.
library;

import 'package:drift/drift.dart';

/// Tabel pelanggan — data pembeli pulsa/token.
///
/// Pelanggan bisa dipilih saat membuat transaksi baru,
/// atau bisa menggunakan "Umum" untuk pelanggan tanpa nama.
@DataClassName('Pelanggan')
class PelangganTable extends Table {
  /// ID auto-increment
  IntColumn get id => integer().autoIncrement()();

  /// Nama pelanggan
  TextColumn get nama => text().withLength(min: 1, max: 100)();

  /// Nomor HP pelanggan (opsional)
  TextColumn get noHp => text().withDefault(const Constant(''))();

  /// Catatan tambahan (opsional)
  TextColumn get catatan => text().withDefault(const Constant(''))();

  /// Saldo piutang (hutang) pelanggan
  IntColumn get saldoPiutang => integer().withDefault(const Constant(0))();

  /// Tanggal pelanggan ditambahkan
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'pelanggan';
}
