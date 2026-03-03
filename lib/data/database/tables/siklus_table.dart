/// Definisi tabel `siklus` untuk database Drift.
///
/// Siklus merepresentasikan satu periode top-up/deposit
/// ke Digiflazz. Setiap siklus memiliki saldo_masuk yang
/// dikonsumsi secara FIFO oleh transaksi.
library;

import 'package:drift/drift.dart';

/// Tabel siklus — menyimpan riwayat deposit/top-up.
///
/// Alur:
/// 1. User transfer uang ke Digiflazz (modal_setor)
/// 2. Dikurangi biaya_admin & biaya_transaksi
/// 3. Saldo_masuk = modal_setor - biaya_admin - biaya_transaksi
/// 4. Saldo_sisa berkurang setiap ada transaksi jual (FIFO)
/// 5. Status otomatis 'selesai' saat saldo_sisa = 0
@DataClassName('Siklus')
class SiklusTable extends Table {
  /// ID auto-increment
  IntColumn get id => integer().autoIncrement()();

  /// Nama/label siklus, misal "Top-up April 2026"
  TextColumn get namaSiklus => text().withLength(min: 1, max: 100)();

  /// Uang yang ditransfer ke Digiflazz (dalam Rupiah)
  IntColumn get modalSetor => integer()();

  /// Potongan dari provider/Digiflazz (dalam Rupiah)
  IntColumn get biayaAdmin => integer().withDefault(const Constant(0))();

  /// Potongan metode pembayaran: QRIS, transfer, dll (dalam Rupiah)
  IntColumn get biayaTransaksi => integer().withDefault(const Constant(0))();

  /// Saldo bersih yang masuk = modal_setor - biaya_admin - biaya_transaksi
  IntColumn get saldoMasuk => integer()();

  /// Sisa saldo dari siklus ini (berkurang setiap transaksi FIFO)
  IntColumn get saldoSisa => integer()();

  /// Tanggal mulai siklus (waktu deposit)
  DateTimeColumn get tanggalMulai =>
      dateTime().withDefault(currentDateAndTime)();

  /// Tanggal selesai (saat saldo habis), nullable
  DateTimeColumn get tanggalSelesai => dateTime().nullable()();

  /// Status siklus: 'aktif' atau 'selesai'
  TextColumn get status => text().withDefault(const Constant('aktif'))();

  @override
  String get tableName => 'siklus';
}
