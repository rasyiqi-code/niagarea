import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/database/app_database.dart';
import '../../providers/core_providers.dart';

class TambahKotakUangScreen extends ConsumerStatefulWidget {
  final KotakUang? kotakUang;

  const TambahKotakUangScreen({super.key, this.kotakUang});

  @override
  ConsumerState<TambahKotakUangScreen> createState() =>
      _TambahKotakUangScreenState();
}

class _TambahKotakUangScreenState extends ConsumerState<TambahKotakUangScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _saldoController;
  late int _iconCode;

  bool get isEdit => widget.kotakUang != null;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.kotakUang?.nama ?? '');
    _saldoController = TextEditingController(
      text: widget.kotakUang?.saldo.toString() ?? '0',
    );
    _iconCode =
        widget.kotakUang?.iconCode ?? Icons.account_balance_wallet.codePoint;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _saldoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final db = ref.read(databaseProvider);
    final nama = _namaController.text.trim();
    final saldo = int.tryParse(_saldoController.text) ?? 0;

    if (isEdit) {
      await db.kotakUangDao.updateKotakUang(
        widget.kotakUang!.copyWith(
          nama: nama,
          saldo: saldo,
          iconCode: drift.Value(_iconCode),
        ),
      );
    } else {
      await db.kotakUangDao.addKotakUang(
        KotakUangTableCompanion.insert(
          nama: nama,
          saldo: drift.Value(saldo),
          iconCode: drift.Value(_iconCode),
        ),
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Kotak Uang' : 'Tambah Kotak Uang'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Wadah (Laci, Bank, dll)',
                prefixIcon: Icon(Icons.label_outline),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Nama tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _saldoController,
              decoration: const InputDecoration(
                labelText: 'Saldo Awal',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              enabled: !isEdit, // Saldo awal hanya saat buat baru
            ),
            const SizedBox(height: 24),
            const Text('Pilih Icon'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                _IconOption(
                  icon: Icons.account_balance_wallet,
                  isSelected:
                      _iconCode == Icons.account_balance_wallet.codePoint,
                  onTap: () => setState(
                    () => _iconCode = Icons.account_balance_wallet.codePoint,
                  ),
                ),
                _IconOption(
                  icon: Icons.account_balance,
                  isSelected: _iconCode == Icons.account_balance.codePoint,
                  onTap: () => setState(
                    () => _iconCode = Icons.account_balance.codePoint,
                  ),
                ),
                _IconOption(
                  icon: Icons.savings,
                  isSelected: _iconCode == Icons.savings.codePoint,
                  onTap: () =>
                      setState(() => _iconCode = Icons.savings.codePoint),
                ),
                _IconOption(
                  icon: Icons.payments,
                  isSelected: _iconCode == Icons.payments.codePoint,
                  onTap: () =>
                      setState(() => _iconCode = Icons.payments.codePoint),
                ),
                _IconOption(
                  icon: Icons.qr_code_2,
                  isSelected: _iconCode == Icons.qr_code_2.codePoint,
                  onTap: () =>
                      setState(() => _iconCode = Icons.qr_code_2.codePoint),
                ),
              ],
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _submit,
              child: Text(isEdit ? 'Simpan Perubahan' : 'Buat Kotak Uang'),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconOption extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _IconOption({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Icon(
          icon,
          color: isSelected
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
