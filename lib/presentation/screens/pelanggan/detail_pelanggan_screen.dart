import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../providers/pelanggan_produk_provider.dart';
import '../../providers/transaksi_provider.dart';
import '../../providers/kotak_uang_provider.dart';
import '../../providers/core_providers.dart';
import '../../../data/daos/transaksi_dao.dart';

class DetailPelangganScreen extends ConsumerWidget {
  final int idPelanggan;

  const DetailPelangganScreen({super.key, required this.idPelanggan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pelangganAsync = ref.watch(pelangganByIdProvider(idPelanggan));
    final transaksiAsync = ref.watch(transaksiPelangganProvider(idPelanggan));

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pelanggan')),
      body: pelangganAsync.when(
        data: (p) {
          if (p == null) {
            return const Center(child: Text('Pelanggan tidak ditemukan'));
          }

          return Column(
            children: [
              // Header Info Pelanggan
              _buildHeader(context, p),

              const Divider(height: 1),

              // Riwayat Transaksi
              Expanded(child: _buildTransactionList(context, transaksiAsync)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic p) {
    final theme = Theme.of(context);
    final hasUtang = p.saldoPiutang > 0;

    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              p.nama[0].toUpperCase(),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            p.nama,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (p.noHp.isNotEmpty)
            Text(
              p.noHp,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 24),

          // Kartu Piutang
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: hasUtang
                  ? theme.colorScheme.errorContainer
                  : theme.colorScheme.primaryContainer.withAlpha(50),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL PIUTANG',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: hasUtang
                            ? theme.colorScheme.onErrorContainer
                            : theme.colorScheme.primary,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CurrencyFormatter.format(p.saldoPiutang),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: hasUtang
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                if (hasUtang)
                  ElevatedButton.icon(
                    onPressed: () => _showBayarDialog(context, p),
                    icon: const Icon(Icons.payments_outlined),
                    label: const Text('Bayar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(
    BuildContext context,
    AsyncValue<List<TransaksiDenganInfo>> asyncList,
  ) {
    final theme = Theme.of(context);

    return asyncList.when(
      data: (list) {
        if (list.isEmpty) {
          return const Center(child: Text('Belum ada transaksi'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final t = list[index].transaksi;
            final isUtang = t.statusBayar == 'utang';

            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              leading: Icon(
                isUtang ? Icons.pending_actions : Icons.check_circle,
                color: isUtang ? theme.colorScheme.error : Colors.green,
              ),
              title: Text(t.namaProduk),
              subtitle: Text(t.createdAt.toString().split('.')[0]),
              trailing: Text(
                CurrencyFormatter.format(t.hargaJual),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  void _showBayarDialog(BuildContext context, dynamic p) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final controller = TextEditingController(
            text: p.saldoPiutang.toString(),
          );
          final kotakUangAsync = ref.watch(kotakUangListProvider);
          int? selectedKotakId;

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Bayar Piutang'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Pembayaran',
                        prefixText: 'Rp ',
                      ),
                    ),
                    const SizedBox(height: 16),
                    kotakUangAsync.when(
                      data: (list) {
                        return DropdownButtonFormField<int>(
                          initialValue: selectedKotakId,
                          decoration: const InputDecoration(
                            labelText: 'Masuk ke Kotak Uang',
                          ),
                          items: list
                              .map(
                                (k) => DropdownMenuItem(
                                  value: k.id,
                                  child: Text(
                                    '${k.nama} (${CurrencyFormatter.format(k.saldo)})',
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedKotakId = val),
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (err, stack) =>
                          const Text('Gagal memuat kotak uang'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: selectedKotakId == null
                        ? null
                        : () async {
                            final amount = int.tryParse(controller.text) ?? 0;
                            if (amount > 0) {
                              final db = ref.read(databaseProvider);
                              // 1. Kurangi piutang pelanggan
                              await db.pelangganDao.updateSaldoPiutang(
                                p.id,
                                -amount,
                              );
                              // 2. Tambah saldo kotak uang
                              await db.kotakUangDao.updateSaldo(
                                selectedKotakId!,
                                amount,
                              );

                              if (context.mounted) {
                                Navigator.pop(context);
                                // Invalidate providers to refresh
                                ref.invalidate(
                                  pelangganByIdProvider(idPelanggan),
                                );
                                ref.invalidate(pelangganProvider);
                                ref.invalidate(kotakUangListProvider);
                              }
                            }
                          },
                    child: const Text('Simpan'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
