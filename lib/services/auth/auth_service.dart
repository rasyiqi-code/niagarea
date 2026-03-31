import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/models/user_profile.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Instance GoogleSignIn static untuk mencegah inisialisasi ganda di Web
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '159543011697-a4866sojd6ohoi0vnovd9h042vl8p6t6.apps.googleusercontent.com',
  );

  // Stream status auth
  Stream<User?> get userStream => _auth.authStateChanges();

  // Ambil profil user dari Firestore
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      // Log error secara internal (bisa menggunakan Crashlytics di masa depan)
      return null;
    }
  }

  // Registrasi user baru
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    required String storeName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Buat profil di Firestore
        final profile = UserProfile(
          uid: credential.user!.uid,
          email: email,
          name: name,
          storeName: storeName,
          role: UserRole.reseller,
          createdAt: DateTime.now(),
          balance: 0.0,
        );

        await _db.collection('users').doc(profile.uid).set(profile.toFirestore());
      }
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Login
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Login menggunakan Akun Google.
  /// Mendukung Web, Android, dan iOS.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Memulai proses Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User membatalkan login

      // 2. Mendapatkan detail autentikasi dari Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Membuat credential Firebase dari token Google
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Melakukan login ke Firebase Auth
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // 5. Cek apakah profil Firestore sudah ada
        final doc = await _db.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          // Buat profil default untuk user baru
          final profile = UserProfile(
            uid: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? '',
            storeName: 'Toko Baru',
            role: UserRole.reseller,
            createdAt: DateTime.now(),
            balance: 0.0,
          );
          await _db.collection('users').doc(user.uid).set(profile.toFirestore());
        }
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
