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

  /// Search users by username
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      _searchResults = await _firestoreService.searchUsers(query);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}