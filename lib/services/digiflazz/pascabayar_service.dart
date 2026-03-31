/// Service untuk menangani alur transaksi Pascabayar Digiflazz.
///
/// Berbeda dengan Prabayar, Pascabayar membutuhkan 2 tahap:
/// 1. Inquiry (Cek Tagihan) -> User konfirmasi detail
/// 2. Payment (Bayar Tagihan) -> Eksekusi pembayaran
library;

import 'digiflazz_client.dart';
import 'digiflazz_models.dart';
import 'package:uuid/uuid.dart';

/// Alur kerja Pascabayar:
/// 1. [inquiry] -> Mendapatkan nominal tagihan & nama pelanggan.
/// 2. [bayar] -> Melakukan pembayaran setelah user setuju.
class PascabayarService {
  final DigiflazzClient _client;
  static const _uuid = Uuid();

  PascabayarService({required DigiflazzClient client}) : _client = client;

  /// Melakukan inquiry tagihan (Cek Tagihan).
  ///
  /// [customerNo] — ID Pelanggan / Nomor Meter.
  /// [buyerSkuCode] — Kode produk pascabayar, misal "PLNPOSTPAID".
  Future<TagihanResponse> inquiry({
    required String customerNo,
    required String buyerSkuCode,
  }) async {
    final refId = _uuid.v4();
    return _client.cekTagihan(
      buyerSkuCode: buyerSkuCode,
      customerNo: customerNo,
      refId: refId,
    );
  }

  /// Melakukan pembayaran tagihan (Bayar Tagihan).
  ///
  /// Harus dipanggil SETELAH inquiry dan user mengonfirmasi biaya.
  /// [refId] harus sama dengan saat inquiry (opsional, tapi disarankan).
  Future<TransaksiDigiflazzResponse> bayar({
    required String customerNo,
    required String buyerSkuCode,
    required String refId,
  }) async {
    return _client.bayarTagihan(
      buyerSkuCode: buyerSkuCode,
      customerNo: customerNo,
      refId: refId,
    );
  }

  /// Utilitas untuk cek nama pelanggan PLN (Token/Pasca).
  Future<InquiryPlnResponse> cekPelangganPln(String customerNo) async {
    return _client.inquiryPln(customerNo);
  }
}
