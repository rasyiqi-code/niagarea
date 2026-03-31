import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firebase/admin_service.dart';
import '../../data/models/user_profile.dart';

/// Provider untuk layanan Admin Firebase.
final adminServiceProvider = Provider<AdminService>((ref) {
  return AdminService();
});

/// Stream provider untuk daftar seluruh user/reseller (khusus Admin).
final allUsersProvider = StreamProvider<List<UserProfile>>((ref) {
  final adminService = ref.watch(adminServiceProvider);
  return adminService.getAllUsers();
});

/// Provider untuk fungsi top-up manual yang bisa dipanggil UI.
final manualTopupProvider = Provider((ref) {
  final adminService = ref.watch(adminServiceProvider);
  
  return (String uid, double amount) async {
    await adminService.manualTopup(uid, amount);
    // Invalidate total saldo if necessary (though Firestore stream will update UI automatically)
  };
});
