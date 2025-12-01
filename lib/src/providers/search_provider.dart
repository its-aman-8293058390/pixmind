import 'package:flutter/material.dart';
import 'package:pixmind/src/models/user_model.dart';
import 'package:pixmind/src/services/firestore_service.dart';

/// SearchProvider manages the search functionality
class SearchProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<UserModel> _searchResults = [];
  bool _isLoading = false;
  
  List<UserModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  /// Search users by username or user ID
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // If query looks like a user ID (long alphanumeric string), search by ID
      if (_isUserId(query)) {
        final user = await _firestoreService.getUserById(query);
        if (user != null) {
          _searchResults = [user];
        } else {
          _searchResults = [];
        }
      } else {
        // Otherwise, search by username
        _searchResults = await _firestoreService.searchUsers(query);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Check if the query looks like a user ID
  bool _isUserId(String query) {
    // Firebase UID is typically 28 characters long and contains alphanumeric characters and sometimes special characters
    // We'll check if it's at least 20 characters and contains no spaces
    return query.length >= 20 && !query.contains(' ') && RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(query);
  }
}