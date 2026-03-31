import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

/// Mengelola credential Digiflazz (username + API key).
///
/// Credential disimpan di Cloud Firestore (koleksi settings/digiflazz)
/// agar tersinkronisasi di semua perangkat Admin.
/// Class ini juga menyediakan helper untuk generate
/// MD5 signature yang dibutuhkan setiap request API.
class DigiflazzConfig {
  final FirebaseFirestore _db;
  
  // Cache lokal agar tidak fetch Firestore tiap detil dibaca
  Map<String, dynamic>? _cache;
  DateTime? _lastFetch;

  DigiflazzConfig({FirebaseFirestore? db}) 
      : _db = db ?? FirebaseFirestore.instance;

  static const String _docPath = 'settings/digiflazz';

  /// Memastikan data terbaru diambil dari cloud.
  Future<Map<String, dynamic>> _ensureLoaded() async {
    // Cache valid selama 5 menit untuk efisiensi
    if (_cache != null && _lastFetch != null && 
        DateTime.now().difference(_lastFetch!).inMinutes < 5) {
      return _cache!;
    }

    try {
      final doc = await _db.doc(_docPath).get();
      _cache = doc.data() ?? {};
      _lastFetch = DateTime.now();
      return _cache!;
    } catch (e) {
      return _cache ?? {};
    }
  }

  // ── Baca Credential (Cloud) ─────────────────────────

  /// Ambil username Digiflazz dari Firestore.
  Future<String?> getUsername() async {
    final data = await _ensureLoaded();
    return data['username'] as String?;
  }

  /// Ambil API key Digiflazz dari Firestore.
  Future<String?> getApiKey() async {
    final data = await _ensureLoaded();
    return data['api_key'] as String?;
  }

  /// Cek apakah mode testing aktif.
  Future<bool> isTestMode() async {
    final data = await _ensureLoaded();
    return data['test_mode'] == true;
  }

  /// Ambil nilai markup global NiagaRea.
  Future<int> getMarkupGlobal() async {
    final data = await _ensureLoaded();
    return data['markup_global'] as int? ?? 0;
  }

  // ── Tulis Credential (Cloud) ────────────────────────

  /// Simpan credential sekaligus (username + API key) ke Firestore.
  Future<void> saveCredential({
    required String username,
    required String apiKey,
  }) async {
    await _db.doc(_docPath).set({
      'username': username,
      'api_key': apiKey,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    
    // Invalidate cache
    _cache = null;
  }

  /// Hapus semua credential tersimpan.
  Future<void> clearCredential() async {
    await _db.doc(_docPath).update({
      'username': FieldValue.delete(),
      'api_key': FieldValue.delete(),
    });
    _cache = null;
  }

  /// Set mode testing (true/false) di Firestore.
  Future<void> setTestMode(bool enabled) async {
    await _db.doc(_docPath).set({
      'test_mode': enabled,
    }, SetOptions(merge: true));
    _cache = null;
  }

  /// Set nilai markup global di Firestore.
  Future<void> setMarkupGlobal(int markup) async {
    await _db.doc(_docPath).set({
      'markup_global': markup,
    }, SetOptions(merge: true));
    _cache = null;
  }

  // ── Validasi ────────────────────────────────────────

  /// Cek apakah credential sudah dikonfigurasi.
  Future<bool> hasCredential() async {
    final username = await getUsername();
    final apiKey = await getApiKey();
    return username != null && username.isNotEmpty &&
           apiKey != null && apiKey.isNotEmpty;
  }

  // ── Signature MD5 (Pure Logic, Tetap) ───────────────

  static String generateSignature({
    required String username,
    required String apiKey,
    required String suffix,
  }) {
    final data = '$username$apiKey$suffix';
    return md5.convert(utf8.encode(data)).toString();
  }
}
