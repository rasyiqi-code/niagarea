/// Dashboard utama NiagaRea.
///
/// Menampilkan ringkasan: saldo internal, siklus aktif,
/// dan 10 transaksi terakhir. Titik masuk ke fitur
/// tambah siklus dan transaksi baru.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/digiflazz_provider.dart';
import '../../providers/siklus_provider.dart';
import '../../providers/transaksi_provider.dart';
import '../../providers/kotak_uang_provider.dart';
import '../keuangan/kotak_uang_list_screen.dart';
import '../pengaturan/pengaturan_screen.dart';
import '../siklus/tambah_siklus_screen.dart';
import '../transaksi/transaksi_baru_screen.dart';

/// Layar dashboard — halaman utama aplikasi.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.bolt, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('NiagaRea'),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PengaturanScreen()),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(totalSaldoInternalProvider);
          ref.invalidate(siklusAktifProvider);
          ref.invalidate(transaksiTerakhirProvider);
          ref.invalidate(kotakUangListProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Kartu Saldo Internal ──────────────────────
            _SaldoCard(),
            const SizedBox(height: 16),

            // ── Tombol Aksi ───────────────────────────────
            _AksiCepat(),
            const SizedBox(height: 24),

            // ── Siklus Aktif ──────────────────────────────
            _SiklusAktifSection(),
            const SizedBox(height: 24),

            // ── Kotak Uang (Tunai/Non-Tunai) ──────────────
            _KotakUangSection(),
            const SizedBox(height: 24),

            // ── Transaksi Terakhir ────────────────────────
            _TransaksiTerakhirSection(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Kartu saldo internal (FIFO) — highlight utama dashboard.
/// Ditambah saldo provider untuk perbandingan.
class _SaldoCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final saldoAsync = ref.watch(totalSaldoInternalProvider);
    final profitAsync = ref.watch(profitHariIniProvider);
    final saldoDgAsync = ref.watch(saldoDigiflazzProvider);
    final isAdmin = ref.watch(isAdminModeProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SALDO ANDA',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary.withAlpha(178),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          saldoAsync.when(
            data: (saldo) => Text(
              CurrencyFormatter.format(saldo),
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            loading: () => Text(
              '...',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            error: (_, _) => Text(
              'Error',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: theme.colorScheme.onPrimary.withAlpha(178),
                size: 16,
              ),
              const SizedBox(width: 4),
              profitAsync.when(
                data: (profit) => Text(
                  'Profit hari ini: ${CurrencyFormatter.format(profit)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary.withAlpha(178),
                  ),
                ),
                loading: () => Text(
                  'Menghitung...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary.withAlpha(178),
                  ),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),

          // ── Saldo Provider (Hanya Admin) ──────────
          if (isAdmin) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.cloud_outlined,
                    color: theme.colorScheme.onPrimary.withAlpha(178),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: saldoDgAsync.when(
                      data: (saldo) => Text(
                        saldo != null
                            ? 'Saldo Stok: ${CurrencyFormatter.format(saldo)}'
                            : 'Stok: belum terhubung',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary.withAlpha(178),
                        ),
                      ),
                      loading: () => Text(
                        'Mengecek stok...',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary.withAlpha(178),
                        ),
                      ),
                      error: (_, _) => Text(
                        'Stok: error',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary.withAlpha(178),
                        ),
                      ),
                    ),
                  ),
                  // Tombol refresh saldo
                  InkWell(
                    onTap: () => ref.invalidate(saldoDigiflazzProvider),
                    child: Icon(
                      Icons.refresh,
                      color: theme.colorScheme.onPrimary.withAlpha(178),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Tombol aksi cepat: Tambah Siklus & Transaksi Baru.
class _AksiCepat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TambahSiklusScreen()),
            ),
            icon: const Icon(Icons.add_card),
            label: const Text('Top-up Saldo'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TransaksiBaruScreen()),
            ),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('+ Jual'),
          ),
        ),
      ],
    );
  }
}

/// Section siklus aktif di dashboard.
class _SiklusAktifSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final siklusAsync = ref.watch(siklusAktifProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RIWAYAT MODAL / SALDO',
          style: theme.textTheme.labelMedium?.copyWith(
            letterSpacing: 1.2,
            color: theme.colorScheme.onSurface.withAlpha(153),
          ),
        ),
        const SizedBox(height: 8),
        siklusAsync.when(
          data: (siklusList) {
            if (siklusList.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Belum ada saldo aktif.\nLakukan top-up pertama!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(128),
                      ),
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: [
                Text(
                  '${siklusList.length} sumber modal aktif',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                ...siklusList.map(
                  (s) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: s.saldoSisa < 10000
                            ? AppColors.warning.withAlpha(51)
                            : theme.colorScheme.primary.withAlpha(25),
                        child: Icon(
                          Icons.account_balance_wallet,
                          color: s.saldoSisa < 10000
                              ? AppColors.warning
                              : theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        s.namaSiklus,
                        style: theme.textTheme.titleSmall,
                      ),
                      subtitle: Text(
                        DateFormatter.formatTanggal(s.tanggalMulai),
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            CurrencyFormatter.format(s.saldoSisa),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (s.saldoSisa < 10000)
                            Text(
                              'Hampir habis',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.warning,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: $e'),
            ),
          ),
        ),
      ],
    );
  }
}

/// Section 10 transaksi terakhir di dashboard.
class _TransaksiTerakhirSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final trxAsync = ref.watch(transaksiTerakhirProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TRANSAKSI TERAKHIR',
          style: theme.textTheme.labelMedium?.copyWith(
            letterSpacing: 1.2,
            color: theme.colorScheme.onSurface.withAlpha(153),
          ),
        ),
        const SizedBox(height: 8),
        trxAsync.when(
          data: (trxList) {
            if (trxList.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Belum ada transaksi.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(128),
                      ),
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: trxList.map((item) {
                final trx = item.transaksi;
                final nama = item.pelanggan?.nama ?? 'Umum';
                final isLunas = trx.statusBayar == 'lunas';

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isLunas
                          ? AppColors.success.withAlpha(25)
                          : AppColors.warning.withAlpha(25),
                      child: Icon(
                        isLunas ? Icons.check_circle : Icons.schedule,
                        color: isLunas ? AppColors.success : AppColors.warning,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      trx.namaProduk,
                      style: theme.textTheme.titleSmall,
                    ),
                    subtitle: Text(
                      '$nama · ${DateFormatter.relatif(trx.createdAt)}',
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.format(trx.hargaJual),
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          '+${CurrencyFormatter.format(trx.profit)}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.profitPositive,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: $e'),
            ),
          ),
        ),
      ],
    );
  }
}

class _KotakUangSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final kotakAsync = ref.watch(kotakUangListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'KOTAK UANG (KAS)',
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 1.2,
                color: theme.colorScheme.onSurface.withAlpha(153),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KotakUangListScreen()),
              ),
              child: const Text('Kelola'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        kotakAsync.when(
          data: (list) {
            if (list.isEmpty) return const SizedBox.shrink();
            return SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final k = list[index];
                  return Container(
                    width: 150,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withAlpha(50),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              IconData(
                                k.iconCode ?? 57895,
                                fontFamily: 'MaterialIcons',
                              ),
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                k.nama,
                                style: theme.textTheme.labelSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          CurrencyFormatter.format(k.saldo),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
