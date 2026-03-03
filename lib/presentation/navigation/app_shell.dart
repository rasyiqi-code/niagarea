/// Navigation shell dengan Bottom Navigation Bar.
///
/// Menyediakan navigasi utama antar 6 tab:
/// Dashboard, Transaksi, Produk, Antrian, Statistik, Pengaturan.
/// Tab Antrian menampilkan badge jumlah pending.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/digiflazz_provider.dart';
import '../screens/antrian/antrian_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/pengaturan/pengaturan_screen.dart';
import '../screens/produk/katalog_produk_screen.dart';
import '../screens/statistik/statistik_screen.dart';
import '../screens/transaksi/riwayat_transaksi_screen.dart';

/// Shell utama aplikasi dengan bottom navigation.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminModeProvider);
    final pendingAsync = ref.watch(jumlahPendingProvider);

    // Filter screens and destinations based on admin mode
    final List<Widget> screens = [
      const DashboardScreen(),
      const RiwayatTransaksiScreen(),
      const KatalogProdukScreen(),
      if (isAdmin) const AntrianScreen(),
      const StatistikScreen(),
      const PengaturanScreen(),
    ];

    final destinations = [
      const NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const NavigationDestination(
        icon: Icon(Icons.receipt_long_outlined),
        selectedIcon: Icon(Icons.receipt_long),
        label: 'Transaksi',
      ),
      const NavigationDestination(
        icon: Icon(Icons.inventory_2_outlined),
        selectedIcon: Icon(Icons.inventory_2),
        label: 'Produk',
      ),
      if (isAdmin)
        NavigationDestination(
          icon: pendingAsync.when(
            data: (count) => count > 0
                ? Badge(
                    label: Text('$count'),
                    child: const Icon(Icons.send_outlined),
                  )
                : const Icon(Icons.send_outlined),
            loading: () => const Icon(Icons.send_outlined),
            error: (_, _) => const Icon(Icons.send_outlined),
          ),
          selectedIcon: pendingAsync.when(
            data: (count) => count > 0
                ? Badge(label: Text('$count'), child: const Icon(Icons.send))
                : const Icon(Icons.send),
            loading: () => const Icon(Icons.send),
            error: (_, _) => const Icon(Icons.send),
          ),
          label: 'Antrian',
        ),
      const NavigationDestination(
        icon: Icon(Icons.bar_chart_outlined),
        selectedIcon: Icon(Icons.bar_chart),
        label: 'Statistik',
      ),
      const NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: 'Pengaturan',
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex.clamp(0, screens.length - 1),
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex.clamp(0, destinations.length - 1),
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: destinations,
      ),
    );
  }
}
