import 'package:drift/drift.dart';

/// Tabel kotak_uang — menyimpan akun/wadah kas (Laci, Bank, QRIS, dll).
@DataClassName('KotakUang')
class KotakUangTable extends Table {
  /// ID auto-increment
  IntColumn get id => integer().autoIncrement()();

  /// Nama wadah uang, misal "Laci Tunai", "Bank BCA", "QRIS Dana"
  TextColumn get nama => text().withLength(min: 1, max: 50)();

  /// Saldo kumulatif di kotak ini (dalam Rupiah)
  IntColumn get saldo => integer().withDefault(const Constant(0))();

  /// Kode icon (MaterialIcons) untuk representasi visual
  IntColumn get iconCode => integer().nullable()();

  /// Warna representasi (hex)
  IntColumn get colorValue => integer().nullable()();

  /// Waktu dibuat
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'kotak_uang';
}
