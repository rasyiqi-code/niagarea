/// Halaman antrian transaksi provider stok.
///
/// Menampilkan daftar transaksi yang pending, sukses,
/// atau gagal dikirim ke API provider. User bisa
/// kirim ulang atau hapus item.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/core_providers.dart';
import '../../providers/digiflazz_provider.dart';

/// Halaman antrian transaksi offline → Provider.
class AntrianScreen extends ConsumerWidget {
  const AntrianScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final antrianAsync = ref.watch(antrianProvider);
    final dgState = ref.watch(digiflazzNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Antrian Kirim'),
        actions: [
          // Tombol proses semua pending
          TextButton.icon(
            onPressed: dgState.isLoading
                ? null
                : () async {
                    final guard = ref.read(adminGuardProvider);
                    final ok = await guard.verifikasiAdmin(context);
                    if (ok) {
                      ref
                          .read(digiflazzNotifierProvider.notifier)
                          .prosesAntrian();
                    }
                  },
            icon: const Icon(Icons.send, size: 18),
            label: const Text('Kirim Semua'),
          ),
        ],
      ),
      body: antrianAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurface.withAlpha(77),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada antrian.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(128),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return _AntrianCard(item: item);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

/// Kartu item antrian dengan aksi kirim ulang / hapus.
class _AntrianCard extends ConsumerWidget {
  final dynamic item;

  const _AntrianCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isSukses = item.statusKirim == StatusKirim.sukses;
    final isGagal = item.statusKirim == StatusKirim.gagal;

    // Warna & ikon berdasarkan status
    final statusColor = isSukses
        ? AppColors.success
        : isGagal
        ? AppColors.error
        : AppColors.warning;
    final statusIcon = isSukses
        ? Icons.check_circle
        : isGagal
        ? Icons.error
        : Icons.schedule;
    final statusLabel = isSukses
        ? 'Sukses'
        : isGagal
        ? 'Gagal'
        : 'Pending';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withAlpha(25),
          child: Icon(statusIcon, color: statusColor, size: 22),
        ),
        title: Text(
          item.kodeProduk as String,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tujuan: ${item.tujuan}'),
            Text(
              '$statusLabel · ${DateFormatter.relatif(item.createdAt as DateTime)}',
              style: TextStyle(color: statusColor, fontSize: 12),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol kirim ulang (hanya untuk pending/gagal)
            if (!isSukses)
              IconButton(
                onPressed: () async {
                  final guard = ref.read(adminGuardProvider);
                  final ok = await guard.verifikasiAdmin(context);
                  if (ok) {
                    ref
                        .read(digiflazzNotifierProvider.notifier)
                        .kirimUlang(item.id as int);
                  }
                },
                icon: const Icon(Icons.refresh),
                tooltip: 'Kirim Ulang',
              ),
            // Tombol hapus
            IconButton(
              onPressed: () => _konfirmasiHapus(context, ref, item.id as int),
              icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
              tooltip: 'Hapus',
            ),
          ],
        ),
      ),
    );
  }

  /// Konfirmasi sebelum hapus item antrian.
  void _konfirmasiHapus(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus dari Antrian?'),
        content: const Text('Item ini akan dihapus permanen dari antrian.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              final guard = ref.read(adminGuardProvider);
              final ok = await guard.verifikasiAdmin(ctx);
              if (ok) {
                final db = ref.read(databaseProvider);
                await db.antrianDao.hapusAntrian(id);
                ref.invalidate(antrianProvider);
                ref.invalidate(jumlahPendingProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
