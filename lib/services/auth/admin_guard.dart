/// Guard proteksi admin untuk area sensitif.
///
/// Menggunakan PIN 6 digit yang disimpan terenkripsi
/// di flutter_secure_storage. Digunakan untuk melindungi
/// pengaturan Digiflazz dan operasi admin lainnya.
library;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service proteksi admin via PIN.
///
/// PIN disimpan terenkripsi. Jika belum ada PIN,
/// user diminta set PIN baru pertama kali.
class AdminGuard {
  final FlutterSecureStorage _storage;

  /// Key penyimpanan PIN admin
  static const String _pinKey = 'admin_pin';

  /// Panjang PIN yang valid
  static const int pinLength = 6;

  AdminGuard({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  // ── Baca / Tulis PIN ─────────────────────────────────

  /// Cek apakah PIN admin sudah di-set.
  Future<bool> hasPinTerset() async {
    final pin = await _storage.read(key: _pinKey);
    return pin != null && pin.isNotEmpty;
  }

  /// Set PIN admin baru.
  ///
  /// Validasi: harus tepat [pinLength] digit angka.
  /// Throws [ArgumentError] jika format salah.
  Future<void> setPin(String pin) async {
    if (pin.length != pinLength || !RegExp(r'^\d+$').hasMatch(pin)) {
      throw ArgumentError('PIN harus $pinLength digit angka.');
    }
    await _storage.write(key: _pinKey, value: pin);
  }

  /// Verifikasi PIN yang dimasukkan.
  ///
  /// Return true jika cocok, false jika salah.
  Future<bool> verifikasiPin(String inputPin) async {
    final savedPin = await _storage.read(key: _pinKey);
    return savedPin == inputPin;
  }

  /// Hapus PIN admin (reset).
  Future<void> hapusPin() async {
    await _storage.delete(key: _pinKey);
  }

  // ── Dialog UI ──────────────────────────────────────────

  /// Tampilkan dialog verifikasi admin.
  ///
  /// Jika PIN belum di-set → tampilkan dialog set PIN baru.
  /// Jika sudah ada → tampilkan dialog input PIN.
  ///
  /// Return `true` jika berhasil terverifikasi.
  Future<bool> verifikasiAdmin(BuildContext context) async {
    final hasPin = await hasPinTerset();

    if (!hasPin) {
      // Belum ada PIN — minta set PIN baru
      if (!context.mounted) return false;
      return await _showSetPinDialog(context);
    } else {
      // Sudah ada PIN — minta verifikasi
      if (!context.mounted) return false;
      return await _showInputPinDialog(context);
    }
  }

  /// Dialog set PIN baru (pertama kali).
  Future<bool> _showSetPinDialog(BuildContext context) async {
    final pinCtrl = TextEditingController();
    final konfirmasiCtrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Set PIN Admin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Buat PIN 6 digit untuk melindungi '
              'pengaturan API Digiflazz.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pinCtrl,
              obscureText: true,
              maxLength: pinLength,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: const InputDecoration(
                labelText: 'PIN Baru',
                counterText: '',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: konfirmasiCtrl,
              obscureText: true,
              maxLength: pinLength,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: const InputDecoration(
                labelText: 'Konfirmasi PIN',
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              final pin = pinCtrl.text.trim();
              final konfirmasi = konfirmasiCtrl.text.trim();

              if (pin.length != pinLength) {
                _showError(ctx, 'PIN harus $pinLength digit.');
                return;
              }
              if (pin != konfirmasi) {
                _showError(ctx, 'Konfirmasi PIN tidak cocok.');
                return;
              }

              try {
                await setPin(pin);
                if (ctx.mounted) Navigator.pop(ctx, true);
              } catch (e) {
                if (ctx.mounted) _showError(ctx, e.toString());
              }
            },
            child: const Text('Simpan PIN'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Dialog input PIN untuk verifikasi.
  Future<bool> _showInputPinDialog(BuildContext context) async {
    final pinCtrl = TextEditingController();
    int percobaan = 0;
    const maxPercobaan = 5;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Masukkan PIN Admin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pinCtrl,
                obscureText: true,
                maxLength: pinLength,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                autofocus: true,
                style: const TextStyle(fontSize: 24, letterSpacing: 8),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '• ' * pinLength,
                  errorText: percobaan > 0
                      ? 'PIN salah ($percobaan/$maxPercobaan)'
                      : null,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                final ok = await verifikasiPin(pinCtrl.text.trim());
                if (ok) {
                  if (ctx.mounted) Navigator.pop(ctx, true);
                } else {
                  percobaan++;
                  if (percobaan >= maxPercobaan) {
                    if (ctx.mounted) Navigator.pop(ctx, false);
                    return;
                  }
                  pinCtrl.clear();
                  setState(() {}); // Refresh error text
                }
              },
              child: const Text('Masuk'),
            ),
          ],
        ),
      ),
    );

    return result ?? false;
  }

  /// Tampilkan dialog ubah PIN.
  Future<bool> ubahPin(BuildContext context) async {
    // Verifikasi PIN lama dulu
    final ok = await _showInputPinDialog(context);
    if (!ok || !context.mounted) return false;

    // Lalu set PIN baru
    return await _showSetPinDialog(context);
  }

  /// Helper: snackbar error.
  void _showError(BuildContext context, String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }
}
