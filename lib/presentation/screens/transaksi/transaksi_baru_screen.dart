/// Form transaksi baru — penjualan pulsa/token.
///
/// Menampilkan pilihan pelanggan & produk, menghitung
/// profit otomatis, dan memproses FIFO saat submit.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../domain/fifo/fifo_engine.dart';
import '../../providers/pelanggan_produk_provider.dart';
import '../../providers/transaksi_provider.dart';

/// form transaksi baru — jual produk ke pelanggan.
class TransaksiBaruScreen extends ConsumerStatefulWidget {
  const TransaksiBaruScreen({super.key});

  @override
  ConsumerState<TransaksiBaruScreen> createState() =>
      _TransaksiBaruScreenState();
}

class _TransaksiBaruScreenState extends ConsumerState<TransaksiBaruScreen> {
  Pelanggan? _selectedPelanggan;
  Produk? _selectedProduk;
  String _statusBayar = StatusBayar.lunas;
  final _tujuanController = TextEditingController();
  final _catatanController = TextEditingController();

  /// Profit = harga_jual - harga_beli
  int get _profit =>
      (_selectedProduk?.hargaJual ?? 0) - (_selectedProduk?.hargaBeli ?? 0);

  @override
  void dispose() {
    _tujuanController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  /// Submit transaksi.
  Future<void> _submit() async {
    if (_selectedProduk == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih produk terlebih dahulu')),
      );
      return;
    }

    final produk = _selectedProduk!;

    final id = await ref
        .read(transaksiNotifierProvider.notifier)
        .buatTransaksi(
          idPelanggan: _selectedPelanggan?.id,
          idProduk: produk.id,
          namaProduk: produk.nama,
          hargaBeli: produk.hargaBeli,
          hargaJual: produk.hargaJual,
          statusBayar: _statusBayar,
          tujuan: _tujuanController.text.trim(),
          catatan: _catatanController.text.trim(),
        );

    if (id != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Transaksi berhasil! '
            'Profit: ${CurrencyFormatter.format(_profit)}',
          ),
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      // Tampilkan error dari state
      final state = ref.read(transaksiNotifierProvider);
      state.whenOrNull(
        error: (e, _) {
          String msg = 'Gagal membuat transaksi';
          if (e is InsufficientBalanceException) {
            msg = e.message;
          } else if (e is NoActiveCycleException) {
            msg = e.message;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.red),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pelangganAsync = ref.watch(pelangganProvider);
    final produkAsync = ref.watch(produkAktifProvider);
    final state = ref.watch(transaksiNotifierProvider);
    final isLoading = state is AsyncLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi Baru')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Pilih Pelanggan ──────────────────────────
          Text('Pelanggan', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          pelangganAsync.when(
            data: (list) => DropdownButtonFormField<Pelanggan>(
              initialValue: _selectedPelanggan,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
                hintText: 'Pilih pelanggan...',
              ),
              items: list
                  .map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text(
                        '${p.nama} ${p.noHp.isNotEmpty ? "(${p.noHp})" : ""}',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (p) {
                setState(() {
                  _selectedPelanggan = p;
                  if (p != null && p.noHp.isNotEmpty) {
                    _tujuanController.text = p.noHp;
                  }
                });
              },
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const Text('Gagal memuat pelanggan'),
          ),
          const SizedBox(height: 16),

          // ── Pilih Produk ────────────────────────────
          Text('Produk', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          produkAsync.when(
            data: (list) {
              if (list.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Belum ada produk aktif.\nTambahkan di tab Produk.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(128),
                      ),
                    ),
                  ),
                );
              }
              return DropdownButtonFormField<Produk>(
                initialValue: _selectedProduk,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                  hintText: 'Pilih produk...',
                ),
                items: list
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(
                          '${p.nama} — ${CurrencyFormatter.format(p.hargaJual)}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (p) => setState(() => _selectedProduk = p),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const Text('Gagal memuat produk'),
          ),
          const SizedBox(height: 16),

          // ── Nomor Tujuan ────────────────────────────
          TextFormField(
            controller: _tujuanController,
            decoration: const InputDecoration(
              labelText: 'Nomor Tujuan',
              hintText: '08xxxxxxxxxx',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),

          // ── Ringkasan Harga ─────────────────────────
          if (_selectedProduk != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _HargaRow(
                    label: 'Harga Beli',
                    value: _selectedProduk!.hargaBeli,
                  ),
                  const Divider(),
                  _HargaRow(
                    label: 'Harga Jual',
                    value: _selectedProduk!.hargaJual,
                  ),
                  const Divider(),
                  _HargaRow(label: 'Untung', value: _profit, isProfit: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Status Bayar ────────────────────────────
          Text('Status Bayar', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'lunas',
                label: Text('Lunas'),
                icon: Icon(Icons.check_circle_outline),
              ),
              ButtonSegment(
                value: 'utang',
                label: Text('Utang'),
                icon: Icon(Icons.schedule),
              ),
            ],
            selected: {_statusBayar},
            onSelectionChanged: (v) => setState(() => _statusBayar = v.first),
          ),
          const SizedBox(height: 16),

          // ── Catatan ─────────────────────────────────
          TextFormField(
            controller: _catatanController,
            decoration: const InputDecoration(
              labelText: 'Catatan (opsional)',
              prefixIcon: Icon(Icons.note_outlined),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 32),

          // ── Tombol Submit ───────────────────────────
          ElevatedButton.icon(
            onPressed: isLoading ? null : _submit,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(isLoading ? 'Memproses...' : 'Simpan Transaksi'),
          ),
        ],
      ),
    );
  }
}

/// Widget baris harga di ringkasan.
class _HargaRow extends StatelessWidget {
  final String label;
  final int value;
  final bool isProfit;

  const _HargaRow({
    required this.label,
    required this.value,
    this.isProfit = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            CurrencyFormatter.format(value),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: isProfit ? FontWeight.w700 : FontWeight.w500,
              color: isProfit ? (value >= 0 ? Colors.green : Colors.red) : null,
            ),
          ),
        ],
      ),
    );
  }
}
