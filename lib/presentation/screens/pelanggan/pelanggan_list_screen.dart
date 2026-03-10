import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../providers/pelanggan_produk_provider.dart';
import 'detail_pelanggan_screen.dart';

class PelangganListScreen extends ConsumerWidget {
  const PelangganListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pelangganAsync = ref.watch(pelangganProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pelanggan')),
      body: pelangganAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: theme.colorScheme.onSurface.withAlpha(76),
                  ),
                  const SizedBox(height: 16),
                  const Text('Belum ada pelanggan'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final p = list[index];
              final hasUtang = p.saldoPiutang > 0;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: hasUtang
                        ? theme.colorScheme.errorContainer
                        : theme.colorScheme.primaryContainer,
                    child: Text(
                      p.nama[0].toUpperCase(),
                      style: TextStyle(
                        color: hasUtang
                            ? theme.colorScheme.onErrorContainer
                            : theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    p.nama,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(p.noHp.isEmpty ? p.catatan : p.noHp),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (hasUtang) ...[
                        Text(
                          'Piutang',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(p.saldoPiutang),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ] else
                        const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPelangganScreen(idPelanggan: p.id),
                    ),
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
