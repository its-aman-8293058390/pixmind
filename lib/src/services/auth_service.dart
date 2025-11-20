import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// AuthService handles all authentication related operations
/// including sign in, sign up, and user management
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      if (result.user != null) {
        await _firestore.collection('users').doc(result.user!.uid).set({
          'uid': result.user!.uid,
          'email': email,
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
          'profilePicture': '',
          'bio': '',
        });
      }

      return result.user;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;
}