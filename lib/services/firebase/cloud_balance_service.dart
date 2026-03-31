import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_profile.dart';

/// Exception khusus untuk masalah saldo cloud.
class CloudBalanceException implements Exception {
  final String message;
  CloudBalanceException(this.message);
  @override
  String toString() => 'CloudBalanceException: $message';
}

/// Service untuk mengelola saldo user di Firestore.
/// 
/// Menggunakan Firestore Transaction untuk menjamin ACID
/// saat melakukan pemotongan atau penambahan saldo.
class CloudBalanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Mengambil profil user secara real-time.
  Stream<UserProfile> streamProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map(
          (doc) => UserProfile.fromFirestore(doc),
        );
  }

  /// Melakukan pemotongan saldo (Debit) untuk transaksi.
  /// 
  /// [uid] - ID User yang melakukan transaksi.
  /// [amount] - Jumlah yang didebit (harga modal + markup).
  /// [transactionReference] - ID Transaksi untuk catatan (opsional).
  Future<void> debitBalance({
    required String uid,
    required double amount,
    String? transactionReference,
  }) async {
    final userRef = _db.collection('users').doc(uid);

    return _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        throw CloudBalanceException('User tidak ditemukan di cloud.');
      }

      final profile = UserProfile.fromFirestore(snapshot);
      
      if (profile.balance < amount) {
        throw CloudBalanceException(
          'Saldo tidak cukup. Saldo: ${profile.balance}, Dibutuhkan: $amount',
        );
      }

      final newBalance = profile.balance - amount;
      transaction.update(userRef, {'balance': newBalance});

      // Opsional: Catat riwayat di sub-collection jika diperlukan di masa depan
      // transaction.set(userRef.collection('transactions').doc(), { ... });
    });
  }

  /// Melakukan penambahan saldo (Credit/Top-up).
  /// 
  /// Biasanya dipanggil oleh Admin setelah menerima transfer.
  Future<void> creditBalance({
    required String uid,
    required double amount,
  }) async {
    final userRef = _db.collection('users').doc(uid);

    return _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        throw CloudBalanceException('User tidak ditemukan.');
      }

      final profile = UserProfile.fromFirestore(snapshot);
      final newBalance = profile.balance + amount;
      
      transaction.update(userRef, {'balance': newBalance});
    });
  }
}
