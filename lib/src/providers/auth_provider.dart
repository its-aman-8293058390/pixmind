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
        _user = await _firestoreService.getUserById(user.uid);
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
    String? fullName, // Added full name parameter
    String? bio,
    String? profilePicture,
    DateTime? lastFullNameChange, // Added last full name change parameter
  }) async {
    if (_user == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      await _firestoreService.updateUserProfile(
        uid: _user!.uid,
        username: username,
        fullName: fullName, // Added full name parameter
        bio: bio,
        profilePicture: profilePicture,
        lastFullNameChange: lastFullNameChange, // Added last full name change parameter
      );
      
      // Update local user object
      if (username != null || fullName != null || bio != null || profilePicture != null) _user = UserModel(
        uid: _user!.uid,
        email: _user!.email,
        username: username ?? _user!.username,
        fullName: fullName ?? _user!.fullName, // Added full name to local user object
        bio: bio ?? _user!.bio,
        profilePicture: profilePicture ?? _user!.profilePicture,
        createdAt: _user!.createdAt,
        lastFullNameChange: lastFullNameChange ?? _user!.lastFullNameChange, // Added last full name change to local user object
      );
      
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Check if user can change their full name (only once every 5 days)
  bool canChangeFullName() {
    if (_user == null) return false;
    
    // If user has never changed their full name, they can change it
    if (_user!.lastFullNameChange == null) return true;
    
    // Check if 5 days have passed since last change
    final now = DateTime.now();
    final lastChange = _user!.lastFullNameChange!;
    final difference = now.difference(lastChange);
    
    // Return true if 5 days (or more) have passed
    return difference.inDays >= 5;
  }
}