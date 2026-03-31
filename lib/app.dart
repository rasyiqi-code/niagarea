/// Widget root aplikasi NiagaRea.
///
/// Konfigurasi MaterialApp dengan tema monokrom,
/// routing, dan lokalisasi Indonesia.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'presentation/navigation/auth_wrapper.dart';

/// Widget utama aplikasi NiagaRea.
///
/// Menggunakan [ConsumerWidget] dari Riverpod untuk
/// akses ke global providers.
class NiagaReaApp extends ConsumerWidget {
  const NiagaReaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Tema monokrom hitam-putih
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Halaman utama dengan pengecekan auth
      home: const AuthWrapper(),
    );
  }
}
