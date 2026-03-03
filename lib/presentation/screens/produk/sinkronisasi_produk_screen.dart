/// Halaman sinkronisasi produk dari provider stok.
///
/// Menampilkan list produk hasil sinkronisasi.
/// User bisa toggle aktif/non-aktif dan set harga jual
/// untuk setiap produk.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../providers/core_providers.dart';
import '../../providers/digiflazz_provider.dart';
import '../../providers/pelanggan_produk_provider.dart';

/// Halaman sinkronisasi & manajemen produk dari provider.
class SinkronisasiProdukScreen extends ConsumerStatefulWidget {
  const SinkronisasiProdukScreen({super.key});

  @override
  ConsumerState<SinkronisasiProdukScreen> createState() =>
      _SinkronisasiProdukScreenState();
}

class _SinkronisasiProdukScreenState
    extends ConsumerState<SinkronisasiProdukScreen> {
  /// Filter kategori aktif (null = semua)
  String? _filterKategori;

  /// Search query
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dgState = ref.watch(digiflazzNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Provider'),
        actions: [
          // Tombol sinkronisasi
          TextButton.icon(
            onPressed: dgState.isLoading ? null : _doSync,
            icon: dgState.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync, size: 18),
            label: const Text('Sync'),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search & Filter Bar ──────────────────────
          _SearchFilterBar(
            searchCtrl: _searchCtrl,
            onSearchChanged: (q) => setState(() => _searchQuery = q),
            filterKategori: _filterKategori,
            onFilterChanged: (k) => setState(() => _filterKategori = k),
          ),

          // ── Daftar Produk ────────────────────────────
          Expanded(child: _buildProdukList(theme)),
        ],
      ),
    );
  }

  /// Jalankan sinkronisasi produk.
  Future<void> _doSync() async {
    final notifier = ref.read(digiflazzNotifierProvider.notifier);
    final ok = await notifier.sinkronisasiProduk();

    if (!mounted) return;

    final state = ref.read(digiflazzNotifierProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? (state.sukses ?? 'Sukses') : (state.error ?? 'Gagal'),
        ),
        backgroundColor: ok ? AppColors.success : AppColors.error,
      ),
    );

    // Refresh list produk
    ref.invalidate(semuaProdukProvider);
  }

  /// Build list produk yang sudah tersimpan di lokal.
  Widget _buildProdukList(ThemeData theme) {
    final produkAsync = ref.watch(semuaProdukProvider);

    return produkAsync.when(
      data: (list) {
        // Filter berdasarkan search query dan kategori
        var filtered = list.where((p) {
          final matchSearch =
              _searchQuery.isEmpty ||
              p.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.kodeDigiflazz.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
          final matchKategori =
              _filterKategori == null || p.kategori == _filterKategori;
          return matchSearch && matchKategori;
        }).toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurface.withAlpha(77),
                ),
                const SizedBox(height: 16),
                Text(
                  list.isEmpty
                      ? 'Belum ada produk.\nTekan "Sync" untuk mengambil dari provider.'
                      : 'Tidak ada produk sesuai filter.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(128),
                  ),
                ),
              ],
            ),
          );
        }

        // Kelompokkan berdasarkan kategori
        final grouped = <String, List<Produk>>{};
        for (final p in filtered) {
          grouped.putIfAbsent(p.kategori, () => []).add(p);
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: grouped.length,
          itemBuilder: (context, index) {
            final kategori = grouped.keys.elementAt(index);
            final produkList = grouped[kategori]!;

            return _KategoriSection(kategori: kategori, produkList: produkList);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

/// Bar pencarian dan filter kategori.
class _SearchFilterBar extends StatelessWidget {
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearchChanged;
  final String? filterKategori;
  final ValueChanged<String?> onFilterChanged;

  const _SearchFilterBar({
    required this.searchCtrl,
    required this.onSearchChanged,
    required this.filterKategori,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Search field
          TextField(
            controller: searchCtrl,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Cari produk...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchCtrl.clear();
                        onSearchChanged('');
                      },
                    )
                  : null,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Filter chips kategori
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Semua'),
                  selected: filterKategori == null,
                  onSelected: (_) => onFilterChanged(null),
                ),
                const SizedBox(width: 6),
                for (final k in [
                  'Pulsa',
                  'Paket Data',
                  'Token Listrik',
                  'E-Money',
                  'Voucher Game',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(k),
                      selected: filterKategori == k,
                      onSelected: (_) =>
                          onFilterChanged(filterKategori == k ? null : k),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section per kategori produk.
class _KategoriSection extends ConsumerWidget {
  final String kategori;
  final List<Produk> produkList;

  const _KategoriSection({required this.kategori, required this.produkList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final aktifCount = produkList.where((p) => p.aktif).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(
            children: [
              Text(
                '▼ $kategori',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$aktifCount aktif dari ${produkList.length}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(128),
                ),
              ),
            ],
          ),
        ),
        ...produkList.map((p) => _ProdukItem(produk: p)),
      ],
    );
  }
}

/// Item produk individual dengan toggle aktif & edit harga jual.
class _ProdukItem extends ConsumerWidget {
  final Produk produk;

  const _ProdukItem({required this.produk});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profit = produk.hargaJual - produk.hargaBeli;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        // Toggle aktif
        leading: Checkbox(
          value: produk.aktif,
          onChanged: (val) async {
            final db = ref.read(databaseProvider);
            await db.produkDao.toggleAktif(produk.id, val ?? false);
            ref.invalidate(semuaProdukProvider);
          },
        ),
        title: Text(
          produk.nama,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: produk.aktif
                ? null
                : theme.colorScheme.onSurface.withAlpha(128),
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              'Beli: ${CurrencyFormatter.format(produk.hargaBeli)}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            Text(
              'Jual: ${CurrencyFormatter.format(produk.hargaJual)}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (profit > 0) ...[
              const SizedBox(width: 8),
              Text(
                '+${CurrencyFormatter.format(profit)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.profitPositive,
                ),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, size: 18),
          tooltip: 'Edit Harga Jual',
          onPressed: () => _editHargaJual(context, ref),
        ),
      ),
    );
  }

  /// Dialog edit harga jual produk.
  void _editHargaJual(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
      text: produk.hargaJual > 0 ? produk.hargaJual.toString() : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Harga Jual: ${produk.nama}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Harga beli: ${CurrencyFormatter.format(produk.hargaBeli)}'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Harga Jual (Rp)',
                prefixText: 'Rp ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              final harga = int.tryParse(controller.text) ?? 0;
              if (harga <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Harga harus lebih dari 0')),
                );
                return;
              }

              final db = ref.read(databaseProvider);
              await db.produkDao.updateHargaJual(produk.id, harga);
              ref.invalidate(semuaProdukProvider);

              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
