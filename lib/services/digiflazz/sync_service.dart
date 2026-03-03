/// Service sinkronisasi produk dari API Digiflazz ke database lokal.
///
/// Mengambil daftar harga dari Digiflazz dan menyimpannya
/// ke tabel `produk` lokal via bulk upsert.
library;

import 'package:drift/drift.dart';

import '../../data/daos/produk_dao.dart';
import '../../data/database/app_database.dart';
import 'digiflazz_client.dart';
import 'digiflazz_models.dart';

/// Hasil sinkronisasi produk.
class SyncResult {
  /// Total produk yang diterima dari API
  final int totalDariApi;

  /// Total produk yang berhasil di-upsert ke database
  final int totalDisimpan;

  /// Total produk yang di-skip (status non-aktif di Digiflazz)
  final int totalDiSkip;

  /// Pesan ringkasan
  final String pesan;

  const SyncResult({
    required this.totalDariApi,
    required this.totalDisimpan,
    required this.totalDiSkip,
    required this.pesan,
  });
}

/// Service untuk sinkronisasi produk Digiflazz ke database lokal.
///
/// Alur kerja:
/// 1. Panggil API daftar harga Digiflazz
/// 2. Filter produk yang aktif di Digiflazz
/// 3. Map ke format database lokal
/// 4. Bulk upsert ke tabel produk
class SyncService {
  final DigiflazzClient _client;
  final ProdukDao _produkDao;

  SyncService({required DigiflazzClient client, required ProdukDao produkDao})
    : _client = client,
      _produkDao = produkDao;

  /// Sinkronisasi daftar produk dari Digiflazz ke database lokal.
  ///
  /// [cmd] — "prepaid" untuk prabayar (default), "pasca" untuk pascabayar.
  /// [simpanSemuaStatus] — jika true, simpan juga produk non-aktif.
  ///
  /// Mengembalikan [SyncResult] berisi statistik proses.
  /// Throws [DigiflazzException] jika API gagal.
  Future<SyncResult> sinkronisasiProduk({
    String cmd = 'prepaid',
    bool simpanSemuaStatus = false,
  }) async {
    // 1. Ambil daftar harga dari API
    final response = await _client.ambilDaftarHarga(cmd: cmd);
    final semuaProduk = response.data;

    if (semuaProduk.isEmpty) {
      return const SyncResult(
        totalDariApi: 0,
        totalDisimpan: 0,
        totalDiSkip: 0,
        pesan: 'Tidak ada produk dari provider.',
      );
    }

    // 2. Filter produk yang aktif (kecuali simpanSemuaStatus = true)
    final produkFiltered = simpanSemuaStatus
        ? semuaProduk
        : semuaProduk.where((p) => p.buyerProductStatus).toList();

    final totalDiSkip = semuaProduk.length - produkFiltered.length;

    // 3. Map ke format database (ProdukTableCompanion)
    final companions = produkFiltered.map(_mapToProdukCompanion).toList();

    // 4. Bulk upsert ke database lokal
    await _produkDao.upsertProdukBatch(companions);

    return SyncResult(
      totalDariApi: semuaProduk.length,
      totalDisimpan: produkFiltered.length,
      totalDiSkip: totalDiSkip,
      pesan:
          'Berhasil sinkronisasi ${produkFiltered.length} produk '
          'dari ${semuaProduk.length} total.',
    );
  }

  /// Map [ProdukDigiflazz] ke [ProdukTableCompanion] untuk database.
  ///
  /// Mapping field:
  /// - buyer_sku_code → kode_digiflazz
  /// - product_name → nama
  /// - category → kategori
  /// - brand → brand
  /// - price → harga_beli
  /// - buyer_product_status → aktif (default false, user pilih manual)
  ProdukTableCompanion _mapToProdukCompanion(ProdukDigiflazz produk) {
    return ProdukTableCompanion(
      kodeDigiflazz: Value(produk.buyerSkuCode),
      nama: Value(produk.productName),
      kategori: Value(_normalizeKategori(produk.category)),
      brand: Value(produk.brand),
      hargaBeli: Value(produk.price),
      deskripsi: Value(produk.desc),
      lastUpdated: Value(DateTime.now()),
      // Catatan: 'aktif' dan 'hargaJual' TIDAK di-update saat sync
      // agar setting user tidak tertimpa
    );
  }

  /// Normalisasi nama kategori dari Digiflazz ke format lokal.
  ///
  /// Digiflazz menggunakan nama kategori yang bervariasi,
  /// kita mapping ke set kategori yang konsisten.
  String _normalizeKategori(String kategoriApi) {
    final lower = kategoriApi.toLowerCase();

    if (lower.contains('pulsa')) return 'Pulsa';
    if (lower.contains('data')) return 'Paket Data';
    if (lower.contains('token') || lower.contains('pln')) {
      return 'Token Listrik';
    }
    if (lower.contains('e-money') || lower.contains('emoney')) {
      return 'E-Money';
    }
    if (lower.contains('game') || lower.contains('voucher')) {
      return 'Voucher Game';
    }

    // Gunakan kategori asli jika tidak cocok mapping
    return kategoriApi.isNotEmpty ? kategoriApi : 'Lainnya';
  }
}
