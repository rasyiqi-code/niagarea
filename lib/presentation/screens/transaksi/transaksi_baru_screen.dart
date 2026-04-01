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
import '../../providers/kotak_uang_provider.dart';
import '../../providers/pascabayar_provider.dart';
import '../../widgets/produk_type_badge.dart';
import '../../../services/digiflazz/digiflazz_models.dart';

/// form transaksi baru — jual produk ke pelanggan.
class TransaksiBaruScreen extends ConsumerStatefulWidget {
  const TransaksiBaruScreen({super.key});

  @override
  ConsumerState<TransaksiBaruScreen> createState() =>
      _TransaksiBaruScreenState();
}

class _TransaksiBaruScreenState extends ConsumerState<TransaksiBaruScreen> {
  int? _selectedPelangganId;
  int? _selectedProdukId;
  String _statusBayar = StatusBayar.lunas;
  final _tujuanController = TextEditingController();
  final _catatanController = TextEditingController();
  int? _selectedKotakUangId;
  TagihanResponse? _inquiryData;
  String? _namaPln;

  /// Pelanggan & Produk aktif (diambil dari list saat ini).
  Pelanggan? _getPelanggan(List<Pelanggan> list) =>
      list.where((p) => p.id == _selectedPelangganId).firstOrNull;

  Produk? _getProduk(List<Produk> list) =>
      list.where((p) => p.id == _selectedProdukId).firstOrNull;

  KotakUang? _getKotakUang(List<KotakUang> list) =>
      list.where((k) => k.id == _selectedKotakUangId).firstOrNull;

  /// Profit = harga_jual - harga_beli
  int _getProfit(Produk? p) => (p?.hargaJual ?? 0) - (p?.hargaBeli ?? 0);

  @override
  void dispose() {
    _tujuanController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  /// Submit transaksi.
  Future<void> _submit() async {
    final produkAsync = ref.read(produkAktifProvider);
    final produkList = produkAsync.valueOrNull ?? [];
    final produk = _getProduk(produkList);

    if (produk == null) {
      _showError('Pilih produk terlebih dahulu');
      return;
    }

    final isPasca = (produk.kategori.toLowerCase().contains('pascabayar') ||
            produk.kategori.toLowerCase().contains('tagihan')) &&
        !produk.isManual;

    if (isPasca && _inquiryData == null) {
      _showError('Silakan cek tagihan terlebih dahulu');
      return;
    }

    final profit = _getProfit(produk);
    int? id;
    if (isPasca) {
      id = await ref
          .read(transaksiNotifierProvider.notifier)
          .buatTransaksiPascabayar(
            idPelanggan: _selectedPelangganId,
            idProduk: produk.id,
            namaProduk: produk.nama,
            hargaBeli: _inquiryData!.price,
            hargaJual: _inquiryData!.price + profit, // Harga jual = biaya + profit admin
            statusBayar: _statusBayar,
            idKotakUang: _selectedKotakUangId,
            refId: _inquiryData!.refId,
            tujuan: _tujuanController.text.trim(),
            catatan: _catatanController.text.trim(),
            kodeDigiflazz: produk.kodeDigiflazz,
          );
    } else {
      id = await ref.read(transaksiNotifierProvider.notifier).buatTransaksi(
        idPelanggan: _selectedPelangganId,
        idProduk: produk.id,
        namaProduk: produk.nama,
        hargaBeli: produk.hargaBeli,
        hargaJual: produk.hargaJual,
        statusBayar: _statusBayar,
        idKotakUang: _selectedKotakUangId,
        tujuan: _tujuanController.text.trim(),
        catatan: _catatanController.text.trim(),
        kodeDigiflazz: produk.kodeDigiflazz,
      );
    }

    if (id != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Transaksi berhasil! '
            'Profit: ${CurrencyFormatter.format(profit)}',
          ),
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      final state = ref.read(transaksiNotifierProvider);
      state.whenOrNull(
        error: (e, _) {
          String msg = e.toString();
          if (e is InsufficientBalanceException) msg = e.message;
          _showError(msg);
        },
      );
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  Future<void> _cekTagihan() async {
    final produkList = ref.read(produkAktifProvider).valueOrNull ?? [];
    final produk = _getProduk(produkList);
    final tujuan = _tujuanController.text.trim();

    if (produk == null || tujuan.isEmpty) return;

    await ref.read(pascabayarNotifierProvider.notifier).inquiry(
      customerNo: tujuan,
      buyerSkuCode: produk.kodeDigiflazz,
    );

    final inquiryState = ref.read(pascabayarNotifierProvider);
    if (inquiryState.data != null) {
      setState(() {
        _inquiryData = inquiryState.data;
      });
    } else if (inquiryState.error != null) {
      _showError(inquiryState.error!);
    }
  }

  Future<void> _cekNamaPln() async {
    final tujuan = _tujuanController.text.trim();
    if (tujuan.isEmpty) return;

    final plnData = await ref
        .read(pascabayarNotifierProvider.notifier)
        .cekPelangganPln(tujuan);

    if (plnData != null) {
      setState(() {
        _namaPln = plnData.customerName;
      });
    } else {
      _showError('Gagal mengambil data PLN');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pelangganAsync = ref.watch(pelangganProvider);
    final produkAsync = ref.watch(produkAktifProvider);
    final state = ref.watch(transaksiNotifierProvider);
    final isLoading = state is AsyncLoading;

    final produkList = produkAsync.valueOrNull ?? [];
    final selectedProduk = _getProduk(produkList);

    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi Baru')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Pilih Pelanggan ──────────────────────────
          Text('Pelanggan', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          pelangganAsync.when(
            data: (list) {
              final selected = _getPelanggan(list);
              return DropdownButtonFormField<Pelanggan>(
                initialValue: selected,
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
                    _selectedPelangganId = p?.id;
                    if (p != null && p.noHp.isNotEmpty) {
                      _tujuanController.text = p.noHp;
                    }
                  });
                },
              );
            },
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
              final selected = _getProduk(list);
              return DropdownButtonFormField<Produk>(
                initialValue: selected,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                  hintText: 'Pilih produk...',
                ),
                items: list
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              p.nama,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(width: 8),
                            ProdukTypeBadge(isNiagarea: p.isNiagarea),
                            const SizedBox(width: 8),
                            Text(
                              CurrencyFormatter.format(p.hargaJual),
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (p) => setState(() {
                  _selectedProdukId = p?.id;
                  _inquiryData = null; // Reset inquiry if product changes
                  _namaPln = null;
                }),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const Text('Gagal memuat produk'),
          ),
          const SizedBox(height: 16),

          // ── Nomor Tujuan & Cek ──────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _tujuanController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Tujuan / ID Pelanggan',
                    hintText: '08xxxx / 51xxx',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) {
                    if (_inquiryData != null || _namaPln != null) {
                      setState(() {
                        _inquiryData = null;
                        _namaPln = null;
                      });
                    }
                  },
                ),
              ),
              if (selectedProduk != null) ...[
                const SizedBox(width: 8),
                _buildCekButton(selectedProduk),
              ],
            ],
          ),
          if (_namaPln != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Nama: $_namaPln',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
          ],
          if (_inquiryData != null) ...[
            const SizedBox(height: 16),
            _buildInquiryDetail(),
          ],
          const SizedBox(height: 16),

          // ── Ringkasan Harga ─────────────────────────
          if (selectedProduk != null) ...[
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
                    value: selectedProduk.hargaBeli,
                  ),
                  const Divider(),
                  _HargaRow(
                    label: 'Harga Jual',
                    value: selectedProduk.hargaJual,
                  ),
                  const Divider(),
                  _HargaRow(
                    label: 'Untung',
                    value: _getProfit(selectedProduk),
                    isProfit: true,
                  ),
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

          // ── Pilih Kotak Uang ────────────────────────
          if (_statusBayar == 'lunas') ...[
            Text('Masuk Ke Kotak Uang', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            ref
                .watch(kotakUangListProvider)
                .when(
                  data: (list) {
                    // Set default ke Laci Tunai jika belum pilih
                    if (_selectedKotakUangId == null && list.isNotEmpty) {
                      _selectedKotakUangId = list
                          .firstWhere(
                            (k) => k.nama == 'Laci Tunai',
                            orElse: () => list.first,
                          )
                          .id;
                    }
                    final selected = _getKotakUang(list);
                    return DropdownButtonFormField<KotakUang>(
                      initialValue: selected,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                        hintText: 'Pilih wadah uang...',
                      ),
                      items: list
                          .map(
                            (k) =>
                                DropdownMenuItem(value: k, child: Text(k.nama)),
                          )
                          .toList(),
                      onChanged: (k) =>
                          setState(() => _selectedKotakUangId = k?.id),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (error, stack) =>
                      const Text('Gagal memuat kotak uang'),
                ),
            const SizedBox(height: 16),
          ],

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
            onPressed: (isLoading || _isPascabayarButNoInquiry) ? null : _submit,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(_submitButtonLabel),
          ),
        ],
      ),
    );
  }

  bool get _isPascabayarButNoInquiry {
    final produkList = ref.watch(produkAktifProvider).valueOrNull ?? [];
    final selectedProduk = _getProduk(produkList);
    if (selectedProduk == null || selectedProduk.isManual) return false;
    final isPasca = selectedProduk.kategori.toLowerCase().contains('pasca') ||
        selectedProduk.kategori.toLowerCase().contains('tagihan');
    return isPasca && _inquiryData == null;
  }

  String get _submitButtonLabel {
    final state = ref.watch(transaksiNotifierProvider);
    if (state is AsyncLoading) return 'Memproses...';
    if (_isPascabayarButNoInquiry) return 'Cek Tagihan Dulu';
    return 'Simpan Transaksi';
  }

  Widget _buildCekButton(Produk produk) {
    if (produk.isManual) return const SizedBox.shrink();
    final kategori = produk.kategori.toLowerCase();
    final isPln = kategori.contains('pln');
    final isPasca = kategori.contains('pasca') || kategori.contains('tagihan');

    if (!isPln && !isPasca) return const SizedBox.shrink();

    final inquiryState = ref.watch(pascabayarNotifierProvider);
    final isChecking = inquiryState.isLoading;

    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: isChecking ? null : (isPasca ? _cekTagihan : _cekNamaPln),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isChecking
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(isPasca ? 'Cek Tagihan' : 'Cek Nama'),
      ),
    );
  }

  Widget _buildInquiryDetail() {
    final theme = Theme.of(context);
    final data = _inquiryData!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detail Tagihan', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          _InfoRow(label: 'Nama', value: data.customerName),
          _InfoRow(label: 'Periode', value: data.desc['periode'] ?? '-'),
          _InfoRow(
            label: 'Tagihan',
            value: CurrencyFormatter.format(data.price),
          ),
          _InfoRow(
            label: 'Admin Digiflazz',
            value: CurrencyFormatter.format(data.admin),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontSize: 12))),
          Expanded(flex: 3, child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
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
