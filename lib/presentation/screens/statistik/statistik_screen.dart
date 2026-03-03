/// Halaman statistik — laporan laba-rugi & ringkasan.
///
/// Menampilkan total laba per periode (hari/minggu/bulan),
/// top produk, dan total piutang.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../providers/transaksi_provider.dart';
import '../../providers/core_providers.dart';

/// Provider profit berdasarkan periode.
final _profitPeriodeProvider = FutureProvider.family<int, _Periode>((
  ref,
  periode,
) {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();

  late DateTime dari;
  switch (periode) {
    case _Periode.hari:
      dari = DateTime(now.year, now.month, now.day);
    case _Periode.minggu:
      dari = now.subtract(Duration(days: now.weekday - 1));
      dari = DateTime(dari.year, dari.month, dari.day);
    case _Periode.bulan:
      dari = DateTime(now.year, now.month, 1);
  }

  return db.transaksiDao.hitungTotalProfit(dari, now);
});

/// Provider jumlah transaksi berdasarkan periode.
final _jumlahTrxPeriodeProvider = FutureProvider.family<int, _Periode>((
  ref,
  periode,
) {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();

  late DateTime dari;
  switch (periode) {
    case _Periode.hari:
      dari = DateTime(now.year, now.month, now.day);
    case _Periode.minggu:
      dari = now.subtract(Duration(days: now.weekday - 1));
      dari = DateTime(dari.year, dari.month, dari.day);
    case _Periode.bulan:
      dari = DateTime(now.year, now.month, 1);
  }

  return db.transaksiDao.hitungJumlahTransaksi(dari, now);
});

enum _Periode { hari, minggu, bulan }

/// Halaman statistik.
class StatistikScreen extends ConsumerStatefulWidget {
  const StatistikScreen({super.key});

  @override
  ConsumerState<StatistikScreen> createState() => _StatistikScreenState();
}

class _StatistikScreenState extends ConsumerState<StatistikScreen> {
  _Periode _selectedPeriode = _Periode.hari;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profitAsync = ref.watch(_profitPeriodeProvider(_selectedPeriode));
    final jumlahTrxAsync = ref.watch(
      _jumlahTrxPeriodeProvider(_selectedPeriode),
    );
    final piutangAsync = ref.watch(totalPiutangProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Tab Periode ─────────────────────────────
          SegmentedButton<_Periode>(
            segments: const [
              ButtonSegment(value: _Periode.hari, label: Text('Hari')),
              ButtonSegment(value: _Periode.minggu, label: Text('Minggu')),
              ButtonSegment(value: _Periode.bulan, label: Text('Bulan')),
            ],
            selected: {_selectedPeriode},
            onSelectionChanged: (v) =>
                setState(() => _selectedPeriode = v.first),
          ),
          const SizedBox(height: 24),

          // ── Total Laba ──────────────────────────────
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'TOTAL LABA',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimary.withAlpha(178),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                profitAsync.when(
                  data: (profit) => Text(
                    CurrencyFormatter.format(profit),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  loading: () =>
                      const CircularProgressIndicator(color: Colors.white),
                  error: (_, _) => Text(
                    'Error',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Ringkasan ───────────────────────────────
          Row(
            children: [
              // Jumlah transaksi
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        jumlahTrxAsync.when(
                          data: (jumlah) => Text(
                            '$jumlah',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (_, _) => const Text('-'),
                        ),
                        Text(
                          'Transaksi',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(128),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Piutang
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          color: AppColors.warning,
                        ),
                        const SizedBox(height: 8),
                        piutangAsync.when(
                          data: (piutang) => Text(
                            CurrencyFormatter.formatCompact(piutang),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (_, _) => const Text('-'),
                        ),
                        Text(
                          'Piutang',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(128),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Placeholder Grafik ──────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 48,
                    color: theme.colorScheme.onSurface.withAlpha(76),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Grafik laba akan tampil\nsetelah ada data transaksi',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(128),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
