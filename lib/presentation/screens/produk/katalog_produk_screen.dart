import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/digiflazz_provider.dart';
import '../../providers/pelanggan_produk_provider.dart';
import 'sinkronisasi_produk_screen.dart';

/// Halaman katalog produk dengan proteksi mode online untuk produk Niagarea.
class KatalogProdukScreen extends ConsumerWidget {
  const KatalogProdukScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final produkAsync = ref.watch(produkAktifProvider);
    final isAdmin = ref.watch(isAdminModeProvider);
    final isOffline = ref.watch(isOfflineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Produk'),
        actions: [
          if (isAdmin)
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SinkronisasiProdukScreen()),
                );
              },
              icon: const Icon(Icons.sync, size: 18),
              label: const Text('Sinkron Stok'),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_katalog',
        onPressed: () => _showTambahProdukDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Peringatan jika sedang offline
          if (isOffline) const _OfflineBanner(),
          
          Expanded(
            child: produkAsync.when(
              data: (produkList) {
                if (produkList.isEmpty) {
                  return _buildEmptyState(theme, isAdmin, context);
                }
                return _buildProdukList(theme, produkList, isOffline, context);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProdukList(ThemeData theme, List<Produk> produkList, bool isOffline, BuildContext context) {
    final grouped = <String, List<Produk>>{};
    for (final p in produkList) {
      grouped.putIfAbsent(p.kategori, () => []).add(p);
    }

    final flattenedItems = <dynamic>[];
    final sortedCategories = grouped.keys.toList()..sort();
    for (final kategori in sortedCategories) {
      flattenedItems.add(kategori);
      flattenedItems.addAll(grouped[kategori]!);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: flattenedItems.length,
      itemBuilder: (context, index) {
        final item = flattenedItems[index];

        if (item is String) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '$item (${grouped[item]?.length ?? 0})',
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 1.2,
                color: theme.colorScheme.onSurface.withAlpha(153),
              ),
            ),
          );
        } else {
          final p = item as Produk;
          // Produk Niagarea ditandai dengan kode yang bukan 'manual_'
          final isNiagarea = !p.kodeDigiflazz.startsWith('manual_');
          final isDisabled = isOffline && isNiagarea;
          final profit = p.hargaJual - p.hargaBeli;

          return Card(
            child: ListTile(
              enabled: !isDisabled,
              title: Text(
                p.nama, 
                style: theme.textTheme.titleSmall?.copyWith(
                  color: isDisabled ? theme.colorScheme.onSurface.withAlpha(100) : null,
                ),
              ),
              subtitle: Text(
                'Beli: ${CurrencyFormatter.format(p.hargaBeli)} | Jual: ${CurrencyFormatter.format(p.hargaJual)}',
                style: theme.textTheme.bodySmall,
              ),
              trailing: isDisabled 
                ? const Icon(Icons.cloud_off, size: 16, color: Colors.orange)
                : (profit > 0 ? Text(
                    '+${CurrencyFormatter.format(profit)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.profitPositive,
                      fontWeight: FontWeight.w600,
                    ),
                  ) : null),
              onTap: isDisabled ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Silakan nyalakan paket data untuk transaksi produk Niagarea'),
                    backgroundColor: Colors.orange,
                  ),
                );
              } : null,
            ),
          );
        }
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isAdmin, BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Belum ada produk aktif', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text('Aktifkan produk Niagarea atau tambah manual.', textAlign: TextAlign.center),
          if (isAdmin) ...[
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SinkronisasiProdukScreen()));
              },
              icon: const Icon(Icons.settings_outlined),
              label: const Text('Buka Manajemen Katalog'),
            ),
          ],
        ],
      ),
    );
  }

  void _showTambahProdukDialog(BuildContext context, WidgetRef ref) {
    final namaCtrl = TextEditingController();
    final hargaBeliCtrl = TextEditingController();
    final hargaJualCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 24, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Tambah Produk Manual', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(controller: namaCtrl, decoration: const InputDecoration(labelText: 'Nama Produk')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextFormField(controller: hargaBeliCtrl, decoration: const InputDecoration(labelText: 'Harga Beli'), keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: TextFormField(controller: hargaJualCtrl, decoration: const InputDecoration(labelText: 'Harga Jual'), keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (namaCtrl.text.isEmpty) return;
                final beli = int.tryParse(hargaBeliCtrl.text) ?? 0;
                final jual = int.tryParse(hargaJualCtrl.text) ?? 0;
                await ref.read(produkNotifierProvider.notifier).tambah(
                  nama: namaCtrl.text,
                  kategori: 'Manual',
                  hargaBeli: beli,
                  hargaJual: jual,
                );
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Simpan Produk'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.orange.shade800,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: const Row(
        children: [
          Icon(Icons.cloud_off, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Koneksi terputus. Silakan nyalakan paket data untuk transaksi produk Niagarea.',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
