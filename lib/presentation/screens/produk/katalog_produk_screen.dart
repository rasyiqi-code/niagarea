/// Katalog produk — daftar produk yang dijual.
///
/// Menampilkan produk aktif dengan harga beli, harga jual,
/// dan profit. User bisa menambah produk manual.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../providers/digiflazz_provider.dart';
import '../../providers/pelanggan_produk_provider.dart';
import 'sinkronisasi_produk_screen.dart';

/// Halaman katalog produk.
class KatalogProdukScreen extends ConsumerWidget {
  const KatalogProdukScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final produkAsync = ref.watch(produkAktifProvider);
    final isAdmin = ref.watch(isAdminModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Produk'),
        actions: [
          // Tombol navigasi ke halaman sinkronisasi (Hanya Admin)
          if (isAdmin)
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SinkronisasiProdukScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.sync, size: 18),
              label: const Text('Sinkron Stok'),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTambahProdukDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: produkAsync.when(
        data: (produkList) {
          if (produkList.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurface.withAlpha(76),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada produk',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(128),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan produk manual atau\nsinkronkan dari provider stok',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(102),
                    ),
                  ),
                ],
              ),
            );
          }

          // Kelompokkan per kategori
          final grouped = <String, List<dynamic>>{};
          for (final p in produkList) {
            grouped.putIfAbsent(p.kategori, () => []).add(p);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '${entry.key} (${entry.value.length})',
                      style: theme.textTheme.labelMedium?.copyWith(
                        letterSpacing: 1.2,
                        color: theme.colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                  ),
                  ...entry.value.map((p) {
                    final profit = p.hargaJual - p.hargaBeli;
                    return Card(
                      child: ListTile(
                        title: Text(p.nama, style: theme.textTheme.titleSmall),
                        subtitle: Text(
                          'Beli: ${CurrencyFormatter.format(p.hargaBeli)} '
                          '| Jual: ${CurrencyFormatter.format(p.hargaJual)}',
                          style: theme.textTheme.bodySmall,
                        ),
                        trailing: Text(
                          '+${CurrencyFormatter.format(profit)}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: profit > 0
                                ? AppColors.profitPositive
                                : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                ],
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  /// Dialog tambah produk manual.
  void _showTambahProdukDialog(BuildContext context, WidgetRef ref) {
    final namaCtrl = TextEditingController();
    final hargaBeliCtrl = TextEditingController();
    final hargaJualCtrl = TextEditingController();
    String kategori = KategoriProduk.pulsa;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          24,
          16,
          MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: StatefulBuilder(
          builder: (ctx, setSheetState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Tambah Produk', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: namaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk *',
                  hintText: 'Telkomsel 10k',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: kategori,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: KategoriProduk.semua
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (v) => setSheetState(() => kategori = v ?? kategori),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: hargaBeliCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Harga Beli *',
                        prefixText: 'Rp ',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: hargaJualCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Harga Jual *',
                        prefixText: 'Rp ',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (namaCtrl.text.trim().isEmpty) return;
                  final hargaBeli = CurrencyFormatter.parse(hargaBeliCtrl.text);
                  final hargaJual = CurrencyFormatter.parse(hargaJualCtrl.text);
                  if (hargaBeli <= 0 || hargaJual <= 0) return;

                  await ref
                      .read(produkNotifierProvider.notifier)
                      .tambah(
                        nama: namaCtrl.text.trim(),
                        kategori: kategori,
                        hargaBeli: hargaBeli,
                        hargaJual: hargaJual,
                      );
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('Simpan Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
