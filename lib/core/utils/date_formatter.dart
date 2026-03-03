/// Utilitas pemformatan tanggal & waktu Indonesia.
///
/// Menyediakan helper statis untuk format tanggal
/// dalam locale Indonesia yang konsisten.
library;

import 'package:intl/intl.dart';

/// Helper format tanggal Indonesia.
///
/// Contoh penggunaan:
/// ```dart
/// DateFormatter.formatTanggal(DateTime.now()); // '3 Mar 2026'
/// DateFormatter.formatWaktu(DateTime.now());   // '14:30'
/// DateFormatter.formatLengkap(DateTime.now());  // '3 Maret 2026, 14:30'
/// DateFormatter.relatif(DateTime.now());        // 'Baru saja'
/// ```
class DateFormatter {
  DateFormatter._();

  // ── Formatter statis ────────────────────────────────────
  static final _tanggalPendek = DateFormat('d MMM yyyy', 'id_ID');
  static final _tanggalLengkap = DateFormat('d MMMM yyyy', 'id_ID');
  static final _waktu = DateFormat('HH:mm', 'id_ID');
  static final _tanggalWaktu = DateFormat('d MMM yyyy, HH:mm', 'id_ID');
  static final _hariTanggal = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
  static final _bulanTahun = DateFormat('MMMM yyyy', 'id_ID');

  /// Format tanggal pendek: `3 Mar 2026`
  static String formatTanggal(DateTime date) {
    return _tanggalPendek.format(date);
  }

  /// Format tanggal lengkap: `3 Maret 2026`
  static String formatTanggalLengkap(DateTime date) {
    return _tanggalLengkap.format(date);
  }

  /// Format waktu: `14:30`
  static String formatWaktu(DateTime date) {
    return _waktu.format(date);
  }

  /// Format tanggal + waktu: `3 Mar 2026, 14:30`
  static String formatLengkap(DateTime date) {
    return _tanggalWaktu.format(date);
  }

  /// Format hari + tanggal: `Senin, 3 Maret 2026`
  static String formatHariTanggal(DateTime date) {
    return _hariTanggal.format(date);
  }

  /// Format bulan + tahun: `Maret 2026`
  static String formatBulanTahun(DateTime date) {
    return _bulanTahun.format(date);
  }

  /// Format waktu relatif dari sekarang.
  ///
  /// Contoh: 'Baru saja', '5 menit lalu', '2 jam lalu', 'Kemarin'
  static String relatif(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'Baru saja';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays == 1) {
      return 'Kemarin, ${formatWaktu(date)}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else {
      return formatTanggal(date);
    }
  }
}
