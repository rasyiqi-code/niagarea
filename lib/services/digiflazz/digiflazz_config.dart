/// Konfigurasi credential Digiflazz API.
///
/// Mengelola penyimpanan username dan API key secara
/// terenkripsi menggunakan flutter_secure_storage.
/// Juga menyediakan helper untuk generate signature MD5.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Mengelola credential Digiflazz (username + API key).
///
/// Credential disimpan terenkripsi di secure storage.
/// Class ini juga menyediakan helper untuk generate
/// MD5 signature yang dibutuhkan setiap request API.
class DigiflazzConfig {
  /// Instance secure storage untuk baca/tulis credential
  final FlutterSecureStorage _storage;

  /// Key penyimpanan untuk username Digiflazz
  static const String _usernameKey = 'digiflazz_username';

  /// Key penyimpanan untuk API key Digiflazz
  static const String _apiKeyKey = 'digiflazz_api_key';

  /// Key penyimpanan untuk mode pengujian (testing)
  static const String _testModeKey = 'digiflazz_test_mode';

  DigiflazzConfig({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  // ── Baca Credential ────────────────────────────────

  /// Ambil username Digiflazz dari secure storage.
  Future<String?> getUsername() => _storage.read(key: _usernameKey);

  /// Ambil API key Digiflazz dari secure storage.
  Future<String?> getApiKey() => _storage.read(key: _apiKeyKey);

  /// Cek apakah mode testing aktif.
  Future<bool> isTestMode() async {
    final value = await _storage.read(key: _testModeKey);
    return value == 'true';
  }

  // ── Tulis Credential ────────────────────────────────

  /// Simpan username Digiflazz (terenkripsi).
  Future<void> setUsername(String username) =>
      _storage.write(key: _usernameKey, value: username);

  /// Simpan API key Digiflazz (terenkripsi).
  Future<void> setApiKey(String apiKey) =>
      _storage.write(key: _apiKeyKey, value: apiKey);

  /// Set mode testing (true/false).
  Future<void> setTestMode(bool enabled) =>
      _storage.write(key: _testModeKey, value: enabled.toString());

  /// Simpan credential sekaligus (username + API key).
  Future<void> saveCredential({
    required String username,
    required String apiKey,
  }) async {
    await setUsername(username);
    await setApiKey(apiKey);
  }

  /// Hapus semua credential tersimpan.
  Future<void> clearCredential() async {
    await _storage.delete(key: _usernameKey);
    await _storage.delete(key: _apiKeyKey);
  }

  // ── Validasi ────────────────────────────────────────

  /// Cek apakah credential sudah dikonfigurasi.
  Future<bool> hasCredential() async {
    final username = await getUsername();
    final apiKey = await getApiKey();
    return username != null &&
        username.isNotEmpty &&
        apiKey != null &&
        apiKey.isNotEmpty;
  }

  // ── Signature MD5 ────────────────────────────────────

  /// Generate MD5 signature untuk request API Digiflazz.
  ///
  /// Format: md5(username + apiKey + suffix)
  /// - Cek saldo: suffix = "depo"
  /// - Daftar harga: suffix = "pricelist"
  /// - Transaksi: suffix = ref_id (UUID unik per transaksi)
  static String generateSignature({
    required String username,
    required String apiKey,
    required String suffix,
  }) {
    final data = '$username$apiKey$suffix';
    return md5.convert(utf8.encode(data)).toString();
  }
}
