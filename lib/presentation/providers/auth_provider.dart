import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth/auth_service.dart';
import '../../services/firebase/cloud_balance_service.dart';
import '../../data/models/user_profile.dart';

/// Provider singleton untuk AuthService.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Provider stream status autentikasi Firebase.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).userStream;
});

/// Provider untuk profil user yang sedang login.
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;
  
  if (user == null) return null;
  
  return await ref.read(authServiceProvider).getUserProfile(user.uid);
});

/// Provider untuk mengecek apakah user adalah admin.
final isAdminProvider = Provider<bool>((ref) {
  final profile = ref.watch(userProfileProvider).value;
  return profile?.role == UserRole.admin;
});

/// Provider singleton untuk CloudBalanceService.
final balanceServiceProvider = Provider<CloudBalanceService>((ref) {
  return CloudBalanceService();
});

/// Provider stream untuk saldo user yang sedang login secara real-time.
final cloudBalanceProvider = StreamProvider<double>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;
  
  if (user == null) return Stream.value(0.0);
  
  return ref.watch(balanceServiceProvider)
      .streamProfile(user.uid)
      .map((p) => p.balance);
});
