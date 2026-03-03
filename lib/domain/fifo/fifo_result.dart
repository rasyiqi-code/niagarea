/// Data class hasil operasi FIFO Engine.
///
/// Menyimpan detail konsumsi per siklus setelah
/// transaksi berhasil diproses.
library;

/// Hasil operasi FIFO.
///
/// Berisi total saldo yang dikonsumsi dan
/// breakdown per siklus yang terlibat.
class FifoResult {
  /// Total saldo yang dikonsumsi (= harga_beli produk)
  final int totalDikonsumsi;

  /// Detail konsumsi per siklus (bisa lebih dari satu)
  final List<DetailKonsumsiEntry> detailKonsumsi;

  const FifoResult({
    required this.totalDikonsumsi,
    required this.detailKonsumsi,
  });

  /// Jumlah siklus yang terlibat.
  int get jumlahSiklusTerlibat => detailKonsumsi.length;

  /// Apakah satu siklus habis (selesai) dalam operasi ini.
  bool get adaSiklusSelesai =>
      detailKonsumsi.any((d) => d.saldoSisaSiklus == 0);

  @override
  String toString() {
    final details = detailKonsumsi
        .map(
          (d) =>
              '  ${d.namaSiklus}: -${d.jumlahDikonsumsi} '
              '(sisa: ${d.saldoSisaSiklus})',
        )
        .join('\n');
    return 'FifoResult(total: $totalDikonsumsi)\n$details';
  }
}

/// Entry detail konsumsi dari satu siklus.
class DetailKonsumsiEntry {
  /// ID siklus yang saldonya dikonsumsi
  final int idSiklus;

  /// Nama siklus untuk display
  final String namaSiklus;

  /// Jumlah yang dikonsumsi dari siklus ini
  final int jumlahDikonsumsi;

  /// Sisa saldo siklus setelah konsumsi
  final int saldoSisaSiklus;

  const DetailKonsumsiEntry({
    required this.idSiklus,
    required this.namaSiklus,
    required this.jumlahDikonsumsi,
    required this.saldoSisaSiklus,
  });
}
