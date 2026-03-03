/// Halaman pengaturan — konfigurasi API dan preferensi.
///
/// Menyimpan API key Digiflazz terenkripsi,
/// preferensi harga, dan info aplikasi.
/// Mendukung test koneksi langsung dari halaman ini.
/// Bagian sensitif dilindungi dengan PIN Admin.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/digiflazz_provider.dart';

/// Halaman pengaturan dengan integrasi Digiflazz & Proteksi Admin.
class PengaturanScreen extends ConsumerWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hasCredential = ref.watch(hasCredentialProvider);
    final isAdmin = ref.watch(isAdminModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          const SizedBox(height: 8),

          // ── Provider Stok (Hanya Admin) ──────────────
          if (isAdmin) ...[
            _SectionHeader(title: 'PENGATURAN DATA (ADMIN)'),
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text('API Credential'),
              subtitle: hasCredential.when(
                data: (has) => Text(
                  has ? 'Credential tersimpan ✓' : 'Belum dikonfigurasi',
                  style: TextStyle(
                    color: has ? AppColors.success : AppColors.warning,
                  ),
                ),
                loading: () => const Text('Mengecek...'),
                error: (_, _) => const Text('Error'),
              ),
              onTap: () => _showCredentialDialog(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.wifi_find),
              title: const Text('Test Koneksi'),
              subtitle: const Text('Cek saldo untuk verifikasi API'),
              onTap: () => _testKoneksi(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Sinkronisasi Produk'),
              subtitle: const Text('Ambil daftar produk terbaru'),
              onTap: () => _sinkronisasiProduk(context, ref),
            ),
            const Divider(),
          ],

          // ── Keamanan (Hanya Admin) ──────────────────
          if (isAdmin) ...[
            _SectionHeader(title: 'KEAMANAN'),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: const Text('PIN Admin'),
              subtitle: const Text('Ubah atau setel ulang PIN proteksi'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _kelolaPin(context, ref),
            ),
            const Divider(),
          ],

          // ── Preferensi ──────────────────────────────
          _SectionHeader(title: 'PREFERENSI'),
          if (isAdmin) ...[
            ListTile(
              leading: const Icon(Icons.science_outlined),
              title: const Text('Mode Testing'),
              subtitle: const Text('Transaksi tidak diproses sungguhan'),
              trailing: _TestModeSwitch(),
            ),
          ],
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Tema'),
            subtitle: const Text('Gunakan tema sistem'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),

          // ── Data ────────────────────────────────────
          _SectionHeader(title: 'DATA'),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('Backup Database'),
            subtitle: const Text('Simpan ke penyimpanan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur backup coming soon!')),
              );
            },
          ),
          const Divider(),

          // ── Tentang ─────────────────────────────────
          _SectionHeader(title: 'TENTANG'),
          GestureDetector(
            onLongPress: () => _toggleAdminMode(context, ref),
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text(AppConstants.appName),
              subtitle: Text(
                'v${AppConstants.appVersion}\n${AppConstants.appDescription}',
              ),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 16),
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(isAdminModeProvider.notifier).state = false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Keluar dari mode admin')),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Keluar Mode Admin'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
              ),
            ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Dibuat dengan ❤️ untuk reseller pulsa',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(102),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Dialog input credential Digiflazz.
  void _showCredentialDialog(BuildContext context, WidgetRef ref) {
    final usernameCtrl = TextEditingController();
    final apiKeyCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('API Credential'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameCtrl,
              decoration: const InputDecoration(
                labelText: 'Username Provider',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: apiKeyCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'API Key',
                prefixIcon: Icon(Icons.vpn_key_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(digiflazzNotifierProvider.notifier).hapusCredential();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Credential dihapus.')),
              );
            },
            child: Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              if (usernameCtrl.text.isEmpty || apiKeyCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Username dan API Key wajib diisi.'),
                  ),
                );
                return;
              }

              final notifier = ref.read(digiflazzNotifierProvider.notifier);
              final ok = await notifier.simpanCredential(
                username: usernameCtrl.text.trim(),
                apiKey: apiKeyCtrl.text.trim(),
              );

              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ok ? 'Credential tersimpan!' : 'Gagal menyimpan.',
                    ),
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  /// Test koneksi ke Digiflazz (cek saldo).
  void _testKoneksi(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(digiflazzNotifierProvider.notifier);
    final saldo = await notifier.testKoneksi();

    if (!context.mounted) return;

    final state = ref.read(digiflazzNotifierProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saldo != null
              ? 'Koneksi berhasil! Saldo: Rp $saldo'
              : state.error ?? 'Gagal cek saldo.',
        ),
        backgroundColor: saldo != null ? AppColors.success : AppColors.error,
      ),
    );
  }

  /// Sinkronisasi produk dari Digiflazz.
  void _sinkronisasiProduk(BuildContext context, WidgetRef ref) async {
    // Tampilkan loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Expanded(child: Text('Mengambil produk terbaru...')),
          ],
        ),
      ),
    );

    final notifier = ref.read(digiflazzNotifierProvider.notifier);
    final ok = await notifier.sinkronisasiProduk();

    if (!context.mounted) return;
    Navigator.pop(context); // Tutup loading dialog

    final state = ref.read(digiflazzNotifierProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? (state.sukses ?? 'Sukses') : (state.error ?? 'Gagal'),
        ),
        backgroundColor: ok ? AppColors.success : AppColors.error,
      ),
    );
  }

  /// Toggle mode admin menggunakan pintu rahasia (Long Press).
  Future<void> _toggleAdminMode(BuildContext context, WidgetRef ref) async {
    final isAdmin = ref.read(isAdminModeProvider);
    if (isAdmin) return; // Sudah admin

    final guard = ref.read(adminGuardProvider);
    final ok = await guard.verifikasiAdmin(context);

    if (ok) {
      ref.read(isAdminModeProvider.notifier).state = true;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selamat Datang, Admin! Fitur tambahan diaktifkan.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  /// Menu untuk set/ubah PIN admin.
  Future<void> _kelolaPin(BuildContext context, WidgetRef ref) async {
    final guard = ref.read(adminGuardProvider);
    final hasPin = await guard.hasPinTerset();

    if (!context.mounted) return;

    if (!hasPin) {
      // Belum ada PIN — Langsung set
      final ok = await guard.verifikasiAdmin(context);
      if (ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN Admin berhasil dibuat.')),
        );
      }
    } else {
      // Sudah ada — tawarkan ubah atau hapus
      showModalBottomSheet(
        context: context,
        builder: (ctx) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.lock_reset),
              title: const Text('Ubah PIN Admin'),
              onTap: () async {
                Navigator.pop(ctx);
                final ok = await guard.ubahPin(context);
                if (ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PIN Admin berhasil diubah.')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined),
              title: const Text('Hapus PIN Admin'),
              subtitle: const Text('Menghilangkan proteksi area admin'),
              onTap: () async {
                Navigator.pop(ctx);
                // Konfirmasi hapus harus verifikasi PIN juga
                final ok = await guard.verifikasiAdmin(context);
                if (ok) {
                  await guard.hapusPin();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PIN Admin dihapus.')),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }
  }
}

/// Switch toggle mode testing Digiflazz.
class _TestModeSwitch extends ConsumerStatefulWidget {
  @override
  ConsumerState<_TestModeSwitch> createState() => _TestModeSwitchState();
}

class _TestModeSwitchState extends ConsumerState<_TestModeSwitch> {
  bool _isTestMode = false;

  @override
  void initState() {
    super.initState();
    _loadTestMode();
  }

  Future<void> _loadTestMode() async {
    final config = ref.read(digiflazzConfigProvider);
    final mode = await config.isTestMode();
    if (mounted) setState(() => _isTestMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _isTestMode,
      onChanged: (val) async {
        setState(() => _isTestMode = val);
        final config = ref.read(digiflazzConfigProvider);
        await config.setTestMode(val);
      },
    );
  }
}

/// Widget header section di halaman pengaturan.
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
        ),
      ),
    );
  }
}
