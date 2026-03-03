/// Model data untuk response API Digiflazz.
///
/// Mapping JSON response ke objek Dart yang type-safe.
/// Mencakup response cek saldo, daftar harga, dan transaksi.
library;

/// Response dari endpoint cek saldo Digiflazz.
///
/// Contoh response JSON:
/// ```json
/// {"data": {"deposit": 1250000}}
/// ```
class SaldoResponse {
  /// Jumlah deposit/saldo dalam Rupiah
  final int deposit;

  const SaldoResponse({required this.deposit});

  /// Parse dari JSON response API.
  factory SaldoResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return SaldoResponse(deposit: (data?['deposit'] as num?)?.toInt() ?? 0);
  }
}

/// Data produk dari API Digiflazz (daftar harga).
///
/// Setiap item mewakili satu produk dengan kode SKU,
/// nama, kategori, brand, harga, dan status stok.
class ProdukDigiflazz {
  /// Nama produk, misal "XL 10.000"
  final String productName;

  /// Kategori produk, misal "Pulsa", "Data"
  final String category;

  /// Brand/operator, misal "Telkomsel", "PLN"
  final String brand;

  /// Kode SKU pembeli (buyer_sku_code), misal "xld10"
  final String buyerSkuCode;

  /// Harga beli dari supplier (dalam Rupiah)
  final int price;

  /// Nama penjual/supplier
  final String sellerName;

  /// Status produk aktif/non-aktif di Digiflazz
  final bool buyerProductStatus;

  /// Stok unlimited (true = selalu tersedia)
  final bool unlimitedStock;

  /// Jumlah stok tersisa (jika tidak unlimited)
  final int stock;

  /// Bisa multi-transaksi ke nomor yang sama (true/false)
  final bool multi;

  /// Waktu awal cut-off (format: "HH:mm")
  final String startCutOff;

  /// Waktu akhir cut-off (format: "HH:mm")
  final String endCutOff;

  /// Deskripsi produk (opsional)
  final String desc;

  const ProdukDigiflazz({
    required this.productName,
    required this.category,
    required this.brand,
    required this.buyerSkuCode,
    required this.price,
    this.sellerName = '',
    this.buyerProductStatus = true,
    this.unlimitedStock = false,
    this.stock = 0,
    this.multi = false,
    this.startCutOff = '',
    this.endCutOff = '',
    this.desc = '',
  });

  /// Parse dari JSON item daftar harga.
  factory ProdukDigiflazz.fromJson(Map<String, dynamic> json) {
    return ProdukDigiflazz(
      productName: json['product_name'] as String? ?? '',
      category: json['category'] as String? ?? 'Lainnya',
      brand: json['brand'] as String? ?? '',
      buyerSkuCode: json['buyer_sku_code'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      sellerName: json['seller_name'] as String? ?? '',
      buyerProductStatus: json['buyer_product_status'] as bool? ?? false,
      unlimitedStock: json['unlimited_stock'] as bool? ?? false,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      multi: json['multi'] as bool? ?? false,
      startCutOff: json['start_cut_off'] as String? ?? '',
      endCutOff: json['end_cut_off'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
    );
  }

  /// Konversi ke String untuk debugging.
  @override
  String toString() => 'ProdukDigiflazz($buyerSkuCode, $productName, Rp$price)';
}

/// Response dari endpoint daftar harga Digiflazz.
///
/// Berisi list produk yang tersedia.
class DaftarHargaResponse {
  /// List semua produk dari API
  final List<ProdukDigiflazz> data;

  const DaftarHargaResponse({required this.data});

  /// Parse dari JSON response API.
  factory DaftarHargaResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return DaftarHargaResponse(
      data: dataList
          .map((item) => ProdukDigiflazz.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Response dari endpoint transaksi Digiflazz.
///
/// Berisi status transaksi, harga, serial number, dll.
class TransaksiDigiflazzResponse {
  /// Reference ID unik (dari Buyer)
  final String refId;

  /// Kode SKU produk yang ditransaksikan
  final String buyerSkuCode;

  /// Nomor tujuan pelanggan
  final String customerNo;

  /// Harga yang dipotong dari saldo
  final int price;

  /// Pesan dari Digiflazz (sukses/gagal)
  final String message;

  /// Status transaksi: "Sukses", "Pending", "Gagal"
  final String status;

  /// Response code dari provider
  final String rc;

  /// Serial Number / token (jika ada)
  final String sn;

  const TransaksiDigiflazzResponse({
    required this.refId,
    required this.buyerSkuCode,
    required this.customerNo,
    required this.price,
    required this.message,
    required this.status,
    this.rc = '',
    this.sn = '',
  });

  /// Parse dari JSON response API.
  factory TransaksiDigiflazzResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return TransaksiDigiflazzResponse(
      refId: data['ref_id'] as String? ?? '',
      buyerSkuCode: data['buyer_sku_code'] as String? ?? '',
      customerNo: data['customer_no'] as String? ?? '',
      price: (data['price'] as num?)?.toInt() ?? 0,
      message: data['message'] as String? ?? '',
      status: data['status'] as String? ?? '',
      rc: data['rc'] as String? ?? '',
      sn: data['sn'] as String? ?? '',
    );
  }

  /// Apakah transaksi berhasil.
  bool get isSukses => status.toLowerCase() == 'sukses';

  /// Apakah transaksi masih pending (diproses).
  bool get isPending => status.toLowerCase() == 'pending';

  /// Apakah transaksi gagal.
  bool get isGagal => !isSukses && !isPending;

  @override
  String toString() => 'TransaksiResponse($refId, $status, $message)';
}
