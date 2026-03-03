/// Konstanta global untuk aplikasi NiagaRea.
///
/// Menyimpan nilai-nilai statis yang digunakan
/// di seluruh aplikasi: nama, versi, format, dll.
library;

/// Konstanta umum aplikasi.
class AppConstants {
  AppConstants._();

  /// Nama aplikasi
  static const String appName = 'NiagaRea';

  /// Versi aplikasi
  static const String appVersion = '1.0.0';

  /// Deskripsi singkat
  static const String appDescription =
      'Buku Catatan Pulsa & Token (Offline First)';

  /// Nama file database SQLite
  static const String databaseName = 'niagarea.db';

  /// Versi skema database (increment saat migrasi)
  static const int databaseVersion = 1;
}

/// Konstanta status siklus deposit.
class SiklusStatus {
  SiklusStatus._();

  static const String aktif = 'aktif';
  static const String selesai = 'selesai';
}

/// Konstanta status pembayaran transaksi.
class StatusBayar {
  StatusBayar._();

  static const String lunas = 'lunas';
  static const String utang = 'utang';
}

/// Konstanta status pengiriman ke Digiflazz.
class StatusKirim {
  StatusKirim._();

  static const String pending = 'pending';
  static const String sukses = 'sukses';
  static const String gagal = 'gagal';

  /// Transaksi dicatat manual tanpa melalui API
  static const String manual = 'manual';
}

/// Konstanta kategori produk.
class KategoriProduk {
  KategoriProduk._();

  static const String pulsa = 'Pulsa';
  static const String token = 'Token Listrik';
  static const String paketData = 'Paket Data';
  static const String emoney = 'E-Money';
  static const String voucher = 'Voucher Game';
  static const String lainnya = 'Lainnya';

  /// Semua kategori yang tersedia
  static const List<String> semua = [
    pulsa,
    token,
    paketData,
    emoney,
    voucher,
    lainnya,
  ];
}

/// Konstanta untuk Digiflazz API.
class DigiflazzConstants {
  DigiflazzConstants._();

  /// Base URL API Digiflazz
  static const String baseUrl = 'https://api.digiflazz.com/v1';

  /// Endpoint cek saldo
  static const String cekSaldoEndpoint = '/cek-saldo';

  /// Endpoint daftar harga
  static const String priceListEndpoint = '/price-list';

  /// Endpoint transaksi
  static const String transactionEndpoint = '/transaction';
}
