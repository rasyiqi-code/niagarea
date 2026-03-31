/// HTTP client untuk API Digiflazz.
///
/// Menyediakan 3 endpoint utama:
/// 1. Cek saldo deposit
/// 2. Ambil daftar harga produk
/// 3. Kirim transaksi pembelian
///
/// Semua request menggunakan POST dengan body JSON
/// dan signature MD5 sebagai autentikasi.
library;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import 'digiflazz_config.dart';
import 'digiflazz_models.dart';

/// Client HTTP untuk berkomunikasi dengan API Digiflazz.
///
/// Membutuhkan [DigiflazzConfig] untuk credential dan
/// [Dio] sebagai HTTP engine (bisa di-mock untuk testing).
class DigiflazzClient {
  final DigiflazzConfig _config;
  final Dio _dio;

  DigiflazzClient({required DigiflazzConfig config, Dio? dio})
    : _config = config,
      _dio = dio ?? _createDefaultDio();

  /// Buat Dio instance default dengan konfigurasi optimal.
  static Dio _createDefaultDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: DigiflazzConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Jika berjalan di Web, tambahkan Interceptor untuk membelokkan request ke Cloudflare Worker
    if (kIsWeb) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // 1. Dapatkan URL asli lengkap
            final originalUrl = options.uri.toString();
            
            // 2. Bersihkan baseUrl agar tidak terjadi penggabungan URL yang salah
            options.baseUrl = '';
            
            // 3. Belokkan ke Worker dengan URL asli yang sudah di-encode
            final proxyUrl = 'https://square-lake-6889.crediblemarkofficial.workers.dev/?url=${Uri.encodeComponent(originalUrl)}';
            options.path = proxyUrl;
            
            return handler.next(options);
          },
        ),
      );
    }

    return dio;
  }

  // ── 1. CEK SALDO ─────────────────────────────────────

  /// Cek saldo deposit di Digiflazz.
  ///
  /// Mengembalikan [SaldoResponse] berisi jumlah deposit.
  /// Throws [DigiflazzException] jika gagal.
  Future<SaldoResponse> cekSaldo() async {
    final username = await _config.getUsername();
    final apiKey = await _config.getApiKey();

    _validateCredential(username, apiKey);

    final sign = DigiflazzConfig.generateSignature(
      username: username!,
      apiKey: apiKey!,
      suffix: 'depo',
    );

    try {
      final response = await _dio.post(
        DigiflazzConstants.cekSaldoEndpoint,
        data: {'cmd': 'deposit', 'username': username, 'sign': sign},
      );

      return SaldoResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── 2. DAFTAR HARGA ──────────────────────────────────

  /// Ambil daftar harga produk dari Digiflazz.
  ///
  /// [cmd] — "prepaid" untuk prabayar, "pasca" untuk pascabayar.
  /// Mengembalikan [DaftarHargaResponse] berisi list produk.
  /// Throws [DigiflazzException] jika gagal.
  Future<DaftarHargaResponse> ambilDaftarHarga({String cmd = 'prepaid'}) async {
    final username = await _config.getUsername();
    final apiKey = await _config.getApiKey();

    _validateCredential(username, apiKey);

    final sign = DigiflazzConfig.generateSignature(
      username: username!,
      apiKey: apiKey!,
      suffix: 'pricelist',
    );

    try {
      final response = await _dio.post(
        DigiflazzConstants.priceListEndpoint,
        data: {'cmd': cmd, 'username': username, 'sign': sign},
      );

      return DaftarHargaResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── 3. TRANSAKSI ──────────────────────────────────────

  /// Kirim transaksi pembelian ke Digiflazz.
  ///
  /// [buyerSkuCode] — kode produk, misal "xld10".
  /// [customerNo] — nomor tujuan (HP pelanggan).
  /// [refId] — reference ID unik (UUID) dari aplikasi.
  /// [testing] — jika true, transaksi tidak benar-benar diproses.
  ///
  /// Mengembalikan [TransaksiDigiflazzResponse] berisi status.
  /// Throws [DigiflazzException] jika gagal.
  Future<TransaksiDigiflazzResponse> kirimTransaksi({
    required String buyerSkuCode,
    required String customerNo,
    required String refId,
    bool? testing,
  }) async {
    final username = await _config.getUsername();
    final apiKey = await _config.getApiKey();

    _validateCredential(username, apiKey);

    // Untuk transaksi, suffix = ref_id
    final sign = DigiflazzConfig.generateSignature(
      username: username!,
      apiKey: apiKey!,
      suffix: refId,
    );

    // Cek mode testing dari config jika tidak di-override
    final isTestMode = testing ?? await _config.isTestMode();

    try {
      final response = await _dio.post(
        DigiflazzConstants.transactionEndpoint,
        data: {
          'username': username,
          'buyer_sku_code': buyerSkuCode,
          'customer_no': customerNo,
          'ref_id': refId,
          'sign': sign,
          if (isTestMode) 'testing': true,
        },
      );

      return TransaksiDigiflazzResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── 4. PASCABAYAR (CEK & BAYAR) ───────────────────────

  /// Cek tagihan pascabayar (Inquiry).
  ///
  /// Mengembalikan [TagihanResponse].
  Future<TagihanResponse> cekTagihan({
    required String buyerSkuCode,
    required String customerNo,
    required String refId,
  }) async {
    final username = await _config.getUsername();
    final apiKey = await _config.getApiKey();
    _validateCredential(username, apiKey);

    final sign = DigiflazzConfig.generateSignature(
      username: username!,
      apiKey: apiKey!,
      suffix: refId,
    );

    try {
      final response = await _dio.post(
        DigiflazzConstants.cekTagihanEndpoint,
        data: {
          'commands': 'inq-pasca',
          'username': username,
          'buyer_sku_code': buyerSkuCode,
          'customer_no': customerNo,
          'ref_id': refId,
          'sign': sign,
        },
      );
      return TagihanResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Bayar tagihan pascabayar (Payment).
  ///
  /// Mengembalikan [TransaksiDigiflazzResponse].
  Future<TransaksiDigiflazzResponse> bayarTagihan({
    required String buyerSkuCode,
    required String customerNo,
    required String refId,
  }) async {
    final username = await _config.getUsername();
    final apiKey = await _config.getApiKey();
    _validateCredential(username, apiKey);

    final sign = DigiflazzConfig.generateSignature(
      username: username!,
      apiKey: apiKey!,
      suffix: refId,
    );

    try {
      final response = await _dio.post(
        DigiflazzConstants.bayarTagihanEndpoint,
        data: {
          'commands': 'pay-pasca',
          'username': username,
          'buyer_sku_code': buyerSkuCode,
          'customer_no': customerNo,
          'ref_id': refId,
          'sign': sign,
        },
      );
      return TransaksiDigiflazzResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── 5. UTILITAS & STATUS ──────────────────────────────

  /// Cek status transaksi (Prabayar/Pascabayar).
  Future<TransaksiDigiflazzResponse> cekStatus({
    required String buyerSkuCode,
    required String customerNo,
    required String refId,
  }) async {
    final username = await _config.getUsername();
    final apiKey = await _config.getApiKey();
    _validateCredential(username, apiKey);

    final sign = DigiflazzConfig.generateSignature(
      username: username!,
      apiKey: apiKey!,
      suffix: refId,
    );

    try {
      final response = await _dio.post(
        DigiflazzConstants.cekStatusEndpoint,
        data: {
          'username': username,
          'buyer_sku_code': buyerSkuCode,
          'customer_no': customerNo,
          'ref_id': refId,
          'sign': sign,
        },
      );
      return TransaksiDigiflazzResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Inquiry nama pelanggan PLN (Token/Pasca).
  Future<InquiryPlnResponse> inquiryPln(String customerNo) async {
    final username = await _config.getUsername();
    final apiKey = await _config.getApiKey();
    _validateCredential(username, apiKey);

    final sign = DigiflazzConfig.generateSignature(
      username: username!,
      apiKey: apiKey!,
      suffix: 'pln',
    );

    try {
      final response = await _dio.post(
        DigiflazzConstants.inquiryPlnEndpoint,
        data: {
          'commands': 'pln-subscribe',
          'customer_no': customerNo,
          'username': username,
          'sign': sign,
        },
      );
      return InquiryPlnResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Request tiket deposit.
  Future<DepositResponse> requestDeposit({
    required int amount,
    required String bank,
    required String ownerName,
  }) async {
    final username = await _config.getUsername();
    final apiKey = await _config.getApiKey();
    _validateCredential(username, apiKey);

    final sign = DigiflazzConfig.generateSignature(
      username: username!,
      apiKey: apiKey!,
      suffix: 'deposit',
    );

    try {
      final response = await _dio.post(
        DigiflazzConstants.depositEndpoint,
        data: {
          'username': username,
          'amount': amount,
          'Bank': bank,
          'owner_name': ownerName,
          'sign': sign,
        },
      );
      return DepositResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── Helper ────────────────────────────────────────────

  /// Validasi credential tersedia sebelum request.
  void _validateCredential(String? username, String? apiKey) {
    if (username == null || username.isEmpty) {
      throw DigiflazzException(
        'Username Digiflazz belum dikonfigurasi. '
        'Buka Pengaturan → API Credential.',
        type: DigiflazzErrorType.noCredential,
      );
    }
    if (apiKey == null || apiKey.isEmpty) {
      throw DigiflazzException(
        'API Key Digiflazz belum dikonfigurasi. '
        'Buka Pengaturan → API Credential.',
        type: DigiflazzErrorType.noCredential,
      );
    }
  }

  /// Konversi DioException ke DigiflazzException yang user-friendly.
  DigiflazzException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DigiflazzException(
          'Koneksi timeout. Periksa koneksi internet Anda.',
          type: DigiflazzErrorType.timeout,
          originalError: e,
        );
      case DioExceptionType.connectionError:
        return DigiflazzException(
          'Tidak bisa terhubung ke server Digiflazz. '
          'Periksa koneksi internet Anda.',
          type: DigiflazzErrorType.noInternet,
          originalError: e,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final data = e.response?.data;
        String message = 'Error dari server Digiflazz ($statusCode)';
        if (data is Map<String, dynamic>) {
          message = data['data']?['message'] as String? ?? message;
        }
        return DigiflazzException(
          message,
          type: DigiflazzErrorType.serverError,
          statusCode: statusCode,
          originalError: e,
        );
      default:
        return DigiflazzException(
          'Terjadi kesalahan: ${e.message}',
          type: DigiflazzErrorType.unknown,
          originalError: e,
        );
    }
  }
}

// ── Exception khusus Digiflazz ────────────────────────

/// Tipe error yang bisa terjadi saat berkomunikasi dengan Digiflazz.
enum DigiflazzErrorType {
  /// Credential (username/API key) belum dikonfigurasi
  noCredential,

  /// Tidak ada koneksi internet
  noInternet,

  /// Request timeout
  timeout,

  /// Error dari server Digiflazz (4xx/5xx)
  serverError,

  /// Error tidak diketahui
  unknown,
}

/// Exception untuk error terkait API Digiflazz.
class DigiflazzException implements Exception {
  /// Pesan error yang user-friendly
  final String message;

  /// Tipe error untuk handling di UI
  final DigiflazzErrorType type;

  /// HTTP status code (jika ada)
  final int? statusCode;

  /// Error asli dari Dio (untuk debugging)
  final dynamic originalError;

  const DigiflazzException(
    this.message, {
    required this.type,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'DigiflazzException($type): $message';
}
