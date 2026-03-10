/// Riwayat transaksi — daftar sekuruh transaksi penjualan.
///
/// Menampilkan transaksi dengan info pelanggan, produk,
/// harga, profit, dan status bayar/kirim.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/digiflazz_provider.dart';
import '../../providers/transaksi_provider.dart';
import '../antrian/antrian_screen.dart';
import 'transaksi_baru_screen.dart';

/// Halaman riwayat transaksi.
class RiwayatTransaksiScreen extends ConsumerWidget {
  const RiwayatTransaksiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isAdmin = ref.watch(isAdminModeProvider);
    final pendingAsync = ref.watch(jumlahPendingProvider);
    final trxAsync = ref.watch(transaksiTerakhirProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        actions: [
          if (isAdmin)
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AntrianScreen()),
              ),
              icon: pendingAsync.when(
                data: (count) => count > 0
                    ? Badge(
                        label: Text('$count'),
                        child: const Icon(Icons.send_outlined),
                      )
                    : const Icon(Icons.send_outlined),
                loading: () => const Icon(Icons.send_outlined),
                error: (_, _) => const Icon(Icons.send_outlined),
              ),
              tooltip: 'Antrian Transaksi',
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_riwayat',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TransaksiBaruScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: trxAsync.when(
        data: (trxList) {
          if (trxList.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurface.withAlpha(76),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada transaksi',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(128),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Buat transaksi pertama dengan tombol +',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(102),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trxList.length,
            itemBuilder: (context, index) {
              final item = trxList[index];
              final trx = item.transaksi;
              final nama = item.pelanggan?.nama ?? 'Umum';
              final isLunas = trx.statusBayar == 'lunas';

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isLunas
                        ? AppColors.success.withAlpha(25)
                        : AppColors.warning.withAlpha(25),
                    child: Icon(
                      isLunas ? Icons.check_circle : Icons.schedule,
                      color: isLunas ? AppColors.success : AppColors.warning,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    trx.namaProduk,
                    style: theme.textTheme.titleSmall,
                  ),
                  subtitle: Text(
                    '$nama · ${DateFormatter.relatif(trx.createdAt)}'
                    '${trx.idKotakUang != null ? " · ${item.kotakUang?.nama ?? ""}" : ""}'
                    '${trx.tujuan.isNotEmpty ? " · ${trx.tujuan}" : ""}',
                    style: theme.textTheme.bodySmall,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyFormatter.format(trx.hargaJual),
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        '+${CurrencyFormatter.format(trx.profit)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.profitPositive,
                        ),
                      ),
                      if (!isLunas)
                        Text(
                          'Utang',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
