import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_profile.dart';

class AdminService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Mendapatkan stream semua user (reseller) untuk Admin.
  Stream<List<UserProfile>> getAllUsers() {
    return _db
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UserProfile.fromFirestore(doc)).toList();
    });
  }

  /// Melakukan top-up saldo ke user tertentu secara manual.
  /// [uid] - ID user target.
  /// [amount] - Nominal saldo yang ditambahkan.
  Future<void> manualTopup(String uid, double amount) async {
    try {
      final userDoc = _db.collection('users').doc(uid);
      
      await _db.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDoc);
        if (!snapshot.exists) {
          throw Exception("User tidak ditemukan!");
        }

        final currentBalance = (snapshot.data()?['balance'] ?? 0.0).toDouble();
        transaction.update(userDoc, {
          'balance': currentBalance + amount,
        });
        
        // Log transaksi top-up (Opsional: bisa tambah koleksi topup_history)
        final topupRef = _db.collection('topup_history').doc();
        transaction.set(topupRef, {
          'uid': uid,
          'amount': amount,
          'type': 'manual_admin',
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'success',
        });
      });
    } catch (e) {
      rethrow;
    }
  }
}
