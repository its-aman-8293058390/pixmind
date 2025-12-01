import 'package:flutter/material.dart';
import 'package:pixmind/src/models/post_model.dart';
import 'package:pixmind/src/models/comment_model.dart'; // Added comment model
import 'package:pixmind/src/services/firestore_service.dart';

/// PostProvider manages the posts state of the application
class PostProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<PostModel> _posts = [];
  List<PostModel> _reels = [];
  bool _isLoading = false;
  
  List<PostModel> get posts => _posts;
  List<PostModel> get reels => _reels;
  bool get isLoading => _isLoading;

  /// Load all posts
  void loadPosts() {
    _firestoreService.getPosts().listen((posts) {
      _posts = posts;
      notifyListeners();
    });
  }

  /// Load all reels
  void loadReels() {
    _firestoreService.getReels().listen((reels) {
      _reels = reels;
      notifyListeners();
    });
  }

  /// Load user posts
  void loadUserPosts(String uid) {
    _firestoreService.getUserPosts(uid).listen((posts) {
      _posts = posts;
      notifyListeners();
    });
  }

  /// Create a new post
  Future<void> createPost({
    required String uid,
    required String username,
    required String content,
    String? imageUrl,
    String? videoUrl,
  }) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _firestoreService.createPost(
        uid: uid,
        username: username,
        content: content,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Like a post
  Future<void> likePost(String postId, String userId) async {
    try {
      await _firestoreService.likePost(postId, userId);
      // Refresh posts to show updated like count
      loadPosts();
    } catch (e) {
      rethrow;
    }
  }

  /// Unlike a post
  Future<void> unlikePost(String postId, String userId) async {
    try {
      await _firestoreService.unlikePost(postId, userId);
      // Refresh posts to show updated like count
      loadPosts();
    } catch (e) {
      rethrow;
    }
  }

  /// Save a post
  Future<void> savePost(String postId, String userId) async {
    try {
      await _firestoreService.savePost(postId, userId);
      // Refresh posts to show updated save status
      loadPosts();
    } catch (e) {
      rethrow;
    }
  }

  /// Unsave a post
  Future<void> unsavePost(String postId, String userId) async {
    try {
      await _firestoreService.unsavePost(postId, userId);
      // Refresh posts to show updated save status
      loadPosts();
    } catch (e) {
      rethrow;
    }
  }

  /// Add a comment to a post
  Future<void> addComment(String postId, String userId, String username, String content) async {
    try {
      await _firestoreService.addComment(postId, userId, username, content);
      // Refresh posts to show updated comment count
      loadPosts();
    } catch (e) {
      rethrow;
    }
  }
  
  /// Get comments for a post
  Stream<List<CommentModel>> getComments(String postId) {
    return _firestoreService.getComments(postId);
  }
}