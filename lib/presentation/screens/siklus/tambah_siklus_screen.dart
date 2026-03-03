/// Form tambah siklus baru (deposit top-up).
///
/// Menghitung saldo masuk secara otomatis dari
/// modal_setor - biaya_admin - biaya_transaksi.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../providers/siklus_provider.dart';

/// Form tambah siklus baru.
class TambahSiklusScreen extends ConsumerStatefulWidget {
  const TambahSiklusScreen({super.key});

  @override
  ConsumerState<TambahSiklusScreen> createState() => _TambahSiklusScreenState();
}

class _TambahSiklusScreenState extends ConsumerState<TambahSiklusScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _modalController = TextEditingController();
  final _adminController = TextEditingController(text: '0');
  final _biayaTrxController = TextEditingController(text: '0');

  int _saldoMasuk = 0;

  @override
  void initState() {
    super.initState();
    _modalController.addListener(_hitungSaldoMasuk);
    _adminController.addListener(_hitungSaldoMasuk);
    _biayaTrxController.addListener(_hitungSaldoMasuk);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _modalController.dispose();
    _adminController.dispose();
    _biayaTrxController.dispose();
    super.dispose();
  }

  /// Hitung saldo masuk otomatis.
  void _hitungSaldoMasuk() {
    final modal = CurrencyFormatter.parse(_modalController.text);
    final admin = CurrencyFormatter.parse(_adminController.text);
    final biayaTrx = CurrencyFormatter.parse(_biayaTrxController.text);
    setState(() => _saldoMasuk = modal - admin - biayaTrx);
  }

  /// Submit form.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_saldoMasuk <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo masuk harus lebih dari 0')),
      );
      return;
    }

    final nama = _namaController.text.trim().isEmpty
        ? 'Siklus ${DateTime.now().day}/${DateTime.now().month}'
        : _namaController.text.trim();

    final id = await ref
        .read(siklusNotifierProvider.notifier)
        .tambahSiklus(
          namaSiklus: nama,
          modalSetor: CurrencyFormatter.parse(_modalController.text),
          biayaAdmin: CurrencyFormatter.parse(_adminController.text),
          biayaTransaksi: CurrencyFormatter.parse(_biayaTrxController.text),
        );

    if (id != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Siklus berhasil ditambahkan! '
            'Saldo masuk: ${CurrencyFormatter.format(_saldoMasuk)}',
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(siklusNotifierProvider);
    final isLoading = state is AsyncLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Siklus Baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Nama Siklus ─────────────────────────────
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Siklus (opsional)',
                hintText: 'Misal: Top-up Maret 2026',
                prefixIcon: Icon(Icons.label_outline),
              ),
            ),
            const SizedBox(height: 16),

            // ── Modal Disetor ───────────────────────────
            TextFormField(
              controller: _modalController,
              decoration: const InputDecoration(
                labelText: 'Modal Disetor ke Provider *',
                hintText: '500000',
                prefixIcon: Icon(Icons.payments_outlined),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Wajib diisi';
                if (CurrencyFormatter.parse(v) <= 0) {
                  return 'Harus lebih dari 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ── Biaya Admin ─────────────────────────────
            TextFormField(
              controller: _adminController,
              decoration: const InputDecoration(
                labelText: 'Biaya Admin Provider',
                hintText: '0',
                prefixIcon: Icon(Icons.money_off_outlined),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),

            // ── Biaya Transaksi ─────────────────────────
            TextFormField(
              controller: _biayaTrxController,
              decoration: const InputDecoration(
                labelText: 'Biaya Transaksi (QRIS/Transfer)',
                hintText: '0',
                prefixIcon: Icon(Icons.credit_card_outlined),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),

            // ── Saldo Masuk (readonly) ──────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(13),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withAlpha(51),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'SALDO MASUK',
                    style: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.5,
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.format(_saldoMasuk),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _saldoMasuk > 0
                          ? theme.colorScheme.primary
                          : Colors.red,
                    ),
                  ),
                ],
              ),
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
              label: Text(isLoading ? 'Menyimpan...' : 'Saya Sudah Transfer'),
            ),
          ],
        ),
      ),
    );
  }
}
