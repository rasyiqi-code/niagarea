import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/auth_screen.dart';
import 'app_shell.dart';

/// Wrapper untuk menangani perpindahan halaman
/// berdasarkan status login user.
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // User sudah login, tampilkan aplikasi utama
          return const AppShell();
        } else {
          // User belum login, tampilkan layar login
          return const AuthScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, stack) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}
