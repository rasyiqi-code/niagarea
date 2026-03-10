/// Navigation shell dengan Bottom Navigation Bar.
///
/// Menyediakan navigasi utama antar 6 tab:
/// Dashboard, Transaksi, Produk, Antrian, Statistik, Pengaturan.
/// Tab Antrian menampilkan badge jumlah pending.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/dashboard/dashboard_screen.dart';
import '../screens/pelanggan/pelanggan_list_screen.dart';
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
    // List of screens for the indexed stack (5 main tabs)
    final List<Widget> screens = [
      const DashboardScreen(),
      const PelangganListScreen(),
      const RiwayatTransaksiScreen(),
      const KatalogProdukScreen(),
      const StatistikScreen(),
    ];

    final destinations = [
      const NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const NavigationDestination(
        icon: Icon(Icons.people_outlined),
        selectedIcon: Icon(Icons.people),
        label: 'Pelanggan',
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
      const NavigationDestination(
        icon: Icon(Icons.bar_chart_outlined),
        selectedIcon: Icon(Icons.bar_chart),
        label: 'Statistik',
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
