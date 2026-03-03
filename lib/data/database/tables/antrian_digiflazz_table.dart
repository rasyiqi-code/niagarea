/// Definisi tabel `antrian_digiflazz` untuk database Drift.
///
/// Menyimpan transaksi yang perlu dikirim ke API Digiflazz.
/// Berfungsi sebagai antrian offline — transaksi dicatat dulu,
/// dikirim saat ada koneksi internet.
library;

import 'package:drift/drift.dart';

import 'transaksi_table.dart';

/// Tabel antrian Digiflazz — offline transaction queue.
///
/// Alur:
/// 1. Transaksi dibuat → masuk antrian dengan status 'pending'
/// 2. Saat online → kirim ke API Digiflazz
/// 3. Response diterima → update status 'sukses' / 'gagal'
/// 4. Jika gagal → bisa "Kirim Ulang"
@DataClassName('AntrianDigiflazz')
class AntrianDigiflazzTable extends Table {
  /// ID auto-increment
  IntColumn get id => integer().autoIncrement()();

  /// FK ke transaksi lokal
  IntColumn get idTransaksi => integer().references(TransaksiTable, #id)();

  /// Kode produk Digiflazz (buyer_sku_code)
  TextColumn get kodeProduk => text()();

  /// Nomor tujuan pengisian
  TextColumn get tujuan => text()();

  /// Reference ID unik untuk Digiflazz (UUID)
  TextColumn get refId => text()();

  /// Status pengiriman: 'pending', 'sukses', 'gagal'
  TextColumn get statusKirim => text().withDefault(const Constant('pending'))();

  /// Response JSON mentah dari API Digiflazz (opsional)
  TextColumn get responseApi => text().withDefault(const Constant(''))();

  /// Waktu antrian dibuat
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'antrian_digiflazz';
}
