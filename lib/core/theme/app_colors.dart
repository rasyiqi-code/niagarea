/// Palet warna monokrom untuk aplikasi NiagaRea.
///
/// Menggunakan skema hitam-putih dengan aksen minimal
/// untuk indikator status (sukses, gagal, warning).
library;

import 'package:flutter/material.dart';

/// Kelas konstanta warna aplikasi NiagaRea.
///
/// Desain mengusung tema monokrom premium dengan gradasi
/// abu-abu yang elegan. Warna aksen hanya digunakan
/// untuk indikator status transaksi.
class AppColors {
  AppColors._(); // Tidak bisa di-instantiate

  // ── Warna Utama (Monokrom) ──────────────────────────────
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Abu-abu bertingkat — dari gelap ke terang
  static const Color grey900 = Color(0xFF111111);
  static const Color grey800 = Color(0xFF1E1E1E);
  static const Color grey700 = Color(0xFF2D2D2D);
  static const Color grey600 = Color(0xFF3D3D3D);
  static const Color grey500 = Color(0xFF6B6B6B);
  static const Color grey400 = Color(0xFF8E8E8E);
  static const Color grey300 = Color(0xFFB0B0B0);
  static const Color grey200 = Color(0xFFD4D4D4);
  static const Color grey100 = Color(0xFFEAEAEA);
  static const Color grey50 = Color(0xFFF5F5F5);

  // ── Warna Aksen Status ──────────────────────────────────
  /// Hijau — transaksi sukses, saldo cukup
  static const Color success = Color(0xFF2ECC71);
  static const Color successDark = Color(0xFF27AE60);

  /// Merah — transaksi gagal, error
  static const Color error = Color(0xFFE74C3C);
  static const Color errorDark = Color(0xFFC0392B);

  /// Kuning/amber — warning, pending, saldo menipis
  static const Color warning = Color(0xFFF39C12);
  static const Color warningDark = Color(0xFFE67E22);

  /// Biru — info, sinkronisasi
  static const Color info = Color(0xFF3498DB);
  static const Color infoDark = Color(0xFF2980B9);

  // ── Warna Profit ────────────────────────────────────────
  /// Hijau untuk profit positif
  static const Color profitPositive = Color(0xFF2ECC71);

  /// Merah untuk kerugian
  static const Color profitNegative = Color(0xFFE74C3C);

  // ── Warna Surface (Light Mode) ──────────────────────────
  static const Color surfaceLight = white;
  static const Color backgroundLight = grey50;
  static const Color cardLight = white;
  static const Color dividerLight = grey200;

  // ── Warna Surface (Dark Mode) ───────────────────────────
  static const Color surfaceDark = grey900;
  static const Color backgroundDark = black;
  static const Color cardDark = grey800;
  static const Color dividerDark = grey700;
}
