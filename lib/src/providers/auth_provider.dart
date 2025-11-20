import 'package:flutter/material.dart';
import 'package:pixmind/src/models/user_model.dart';
import 'package:pixmind/src/services/auth_service.dart';
import 'package:pixmind/src/services/firestore_service.dart';

/// AuthProvider manages the authentication state of the application
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  
  UserModel? _user;
  bool _isLoading = false;
  
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _authService.isLoggedIn;

  /// Initialize the provider by checking auth state
  void initialize() {
    _authService.authStateChanges.listen((user) async {
      if (user != null) {
        // Fetch user data from Firestore
        _user = await _firestoreService.getUser(user.uid);
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _authService.signInWithEmailAndPassword(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign up with email, password, and username
  Future<void> signUp(String email, String password, String username) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? username,
    String? bio,
    String? profilePicture,
  }) async {
    if (_user == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      await _firestoreService.updateUserProfile(
        uid: _user!.uid,
        username: username,
        bio: bio,
        profilePicture: profilePicture,
      );
      
      // Update local user object
      if (username != null) _user = UserModel(
        uid: _user!.uid,
        email: _user!.email,
        username: username,
        bio: bio ?? _user!.bio,
        profilePicture: profilePicture ?? _user!.profilePicture,
        createdAt: _user!.createdAt,
      );
      
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}