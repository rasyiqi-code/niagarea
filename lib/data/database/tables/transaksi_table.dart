/// Definisi tabel `transaksi` untuk database Drift.
///
/// Setiap transaksi merepresentasikan satu penjualan
/// produk ke pelanggan. Saldo siklus dipotong
/// menggunakan logika FIFO.
library;

import 'package:drift/drift.dart';

import 'pelanggan_table.dart';
import 'produk_table.dart';

/// Tabel transaksi — catatan penjualan pulsa/token.
///
/// Relasi:
/// - [idPelanggan] → [PelangganTable] (nullable, bisa "Umum")
/// - [idProduk] → [ProdukTable] (nullable, jika produk dihapus)
///
/// Status bayar: 'lunas' atau 'utang'
/// Status kirim: 'pending', 'sukses', 'gagal', 'manual'
@DataClassName('Transaksi')
class TransaksiTable extends Table {
  /// ID auto-increment
  IntColumn get id => integer().autoIncrement()();

  /// FK ke pelanggan (nullable — pelanggan bisa "Umum")
  IntColumn get idPelanggan =>
      integer().nullable().references(PelangganTable, #id)();

  /// FK ke produk (nullable — referensi bisa hilang)
  IntColumn get idProduk => integer().nullable().references(ProdukTable, #id)();

  /// Nama produk (disimpan snapshot agar tetap ada walau produk dihapus)
  TextColumn get namaProduk => text().withDefault(const Constant(''))();

  /// Harga beli saat transaksi terjadi (snapshot, dalam Rupiah)
  IntColumn get hargaBeli => integer()();

  /// Harga jual ke pelanggan (snapshot, dalam Rupiah)
  IntColumn get hargaJual => integer()();

  /// Profit = harga_jual - harga_beli
  IntColumn get profit => integer()();

  /// Status bayar: 'lunas' atau 'utang'
  TextColumn get statusBayar => text().withDefault(const Constant('lunas'))();

  /// Status kirim ke Digiflazz: 'pending', 'sukses', 'gagal', 'manual'
  TextColumn get statusKirim => text().withDefault(const Constant('manual'))();

  /// Nomor tujuan pengisian (no HP pelanggan)
  TextColumn get tujuan => text().withDefault(const Constant(''))();

  /// Catatan tambahan (opsional)
  TextColumn get catatan => text().withDefault(const Constant(''))();

  /// Waktu transaksi dibuat
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'transaksi';
}
