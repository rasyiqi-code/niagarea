import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  admin,
  reseller,
}

class UserProfile {
  final String uid;
  final String email;
  final String name;
  final String storeName;
  final double balance;
  final UserRole role;
  final DateTime createdAt;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.storeName,
    this.balance = 0.0,
    required this.role,
    required this.createdAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      storeName: data['storeName'] ?? '',
      balance: (data['balance'] ?? 0.0).toDouble(),
      role: UserRole.values.firstWhere(
        (e) => e.name == (data['role'] ?? 'reseller'),
        orElse: () => UserRole.reseller,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'storeName': storeName,
      'balance': balance,
      'role': role.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserProfile copyWith({
    String? name,
    String? storeName,
    double? balance,
    UserRole? role,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      name: name ?? this.name,
      storeName: storeName ?? this.storeName,
      balance: balance ?? this.balance,
      role: role ?? this.role,
      createdAt: createdAt,
    );
  }
}
