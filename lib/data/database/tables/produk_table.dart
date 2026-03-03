/// Definisi tabel `produk` untuk database Drift.
///
/// Produk disinkronkan dari API Digiflazz dan disimpan lokal.
/// User bisa memilih produk mana yang aktif dijual
/// dan mengatur harga jual sendiri.
library;

import 'package:drift/drift.dart';

/// Tabel produk — katalog produk dari Digiflazz.
///
/// Kolom harga_beli diambil dari "Harga Terbaik" Digiflazz.
/// Kolom harga_jual diisi manual oleh user.
/// Profit = harga_jual - harga_beli.
@DataClassName('Produk')
class ProdukTable extends Table {
  /// ID auto-increment (internal)
  IntColumn get id => integer().autoIncrement()();

  /// Kode produk dari Digiflazz (buyer_sku_code), misal "xld10"
  TextColumn get kodeDigiflazz => text().withLength(min: 1, max: 50)();

  /// Nama produk, misal "Telkomsel 10k"
  TextColumn get nama => text().withLength(min: 1, max: 200)();

  /// Kategori: Pulsa, Token Listrik, Paket Data, dll.
  TextColumn get kategori => text().withDefault(const Constant('Lainnya'))();

  /// Brand/operator, misal "Telkomsel", "PLN", "XL"
  TextColumn get brand => text().withDefault(const Constant(''))();

  /// Harga beli dari supplier Digiflazz (dalam Rupiah)
  IntColumn get hargaBeli => integer()();

  /// Harga jual ke pelanggan (diisi manual oleh user, dalam Rupiah)
  IntColumn get hargaJual => integer().withDefault(const Constant(0))();

  /// Apakah produk ini aktif dijual oleh user
  BoolColumn get aktif => boolean().withDefault(const Constant(false))();

  /// Deskripsi tambahan dari Digiflazz (opsional)
  TextColumn get deskripsi => text().withDefault(const Constant(''))();

  /// Terakhir diperbarui dari API Digiflazz
  DateTimeColumn get lastUpdated =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'produk';

  @override
  List<Set<Column>> get uniqueKeys => [
    {kodeDigiflazz},
  ];
}
