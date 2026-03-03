/// Utilitas pemformatan mata uang Rupiah.
///
/// Menyediakan helper statis untuk format angka
/// ke format Rupiah Indonesia yang konsisten.
library;

import 'package:intl/intl.dart';

/// Helper format mata uang Rupiah.
///
/// Contoh penggunaan:
/// ```dart
/// CurrencyFormatter.format(500000);  // 'Rp 500.000'
/// CurrencyFormatter.formatCompact(1500000);  // 'Rp 1,5jt'
/// ```
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Formatter dasar Rupiah tanpa desimal
  static final _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  /// Formatter angka tanpa simbol
  static final _numberFormatter = NumberFormat('#,###', 'id_ID');

  /// Format angka ke Rupiah penuh.
  ///
  /// [amount] — jumlah dalam integer (satuan terkecil: Rupiah).
  /// Hasil: `Rp 500.000`
  static String format(int amount) {
    return _formatter.format(amount);
  }

  /// Format angka tanpa simbol mata uang.
  ///
  /// [amount] — jumlah dalam integer.
  /// Hasil: `500.000`
  static String formatNumber(int amount) {
    return _numberFormatter.format(amount);
  }

  /// Format kompak untuk angka besar.
  ///
  /// [amount] — jumlah dalam integer.
  /// Hasil: `Rp 1,5jt`, `Rp 500rb`
  static String formatCompact(int amount) {
    if (amount >= 1000000000) {
      final value = amount / 1000000000;
      return 'Rp ${_formatDecimal(value)}M';
    } else if (amount >= 1000000) {
      final value = amount / 1000000;
      return 'Rp ${_formatDecimal(value)}jt';
    } else if (amount >= 1000) {
      final value = amount / 1000;
      return 'Rp ${_formatDecimal(value)}rb';
    }
    return format(amount);
  }

  /// Format desimal — hilangkan `.0` jika bulat
  static String _formatDecimal(double value) {
    if (value == value.toInt().toDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1).replaceAll('.', ',');
  }

  /// Parse string angka ke integer.
  ///
  /// Menghapus semua karakter non-digit.
  /// "500.000" → 500000, "Rp 1.000" → 1000
  static int parse(String text) {
    final cleaned = text.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleaned) ?? 0;
  }
}
