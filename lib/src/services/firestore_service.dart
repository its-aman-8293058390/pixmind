import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pixmind/src/models/post_model.dart';
import 'package:pixmind/src/models/user_model.dart';
import 'package:pixmind/src/models/comment_model.dart'; // Added comment model

/// FirestoreService handles all Firestore database operations
/// including posts, user data, and search functionality
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all posts ordered by timestamp (newest first)
  Stream<List<PostModel>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return PostModel.fromJson(data);
      }).toList();
    });
  }

  /// Get user posts
  Stream<List<PostModel>> getUserPosts(String uid) {
    return _firestore
        .collection('posts')
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return PostModel.fromJson(data);
      }).toList();
    });
  }

  /// Get all reels ordered by timestamp (newest first)
  Stream<List<PostModel>> getReels() {
    return _firestore
        .collection('posts')
        .where('videoUrl', isNotEqualTo: null)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return PostModel.fromJson(data);
      }).toList();
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
    try {
      await _firestore.collection('posts').add({
        'uid': uid,
        'username': username,
        'content': content,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'likes': 0,
        'comments': 0,
        'likedBy': [],
        'isSaved': false,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Like a post
  Future<void> likePost(String postId, String userId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      final postSnapshot = await postRef.get();
      
      if (postSnapshot.exists) {
        final postData = postSnapshot.data() as Map<String, dynamic>;
        List<dynamic> likedBy = List.from(postData['likedBy'] ?? []);
        
        // Check if user already liked the post
        if (!likedBy.contains(userId)) {
          likedBy.add(userId);
          await postRef.update({
            'likes': FieldValue.increment(1),
            'likedBy': likedBy,
          });
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Unlike a post
  Future<void> unlikePost(String postId, String userId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      final postSnapshot = await postRef.get();
      
      if (postSnapshot.exists) {
        final postData = postSnapshot.data() as Map<String, dynamic>;
        List<dynamic> likedBy = List.from(postData['likedBy'] ?? []);
        
        // Check if user liked the post
        if (likedBy.contains(userId)) {
          likedBy.remove(userId);
          await postRef.update({
            'likes': FieldValue.increment(-1),
            'likedBy': likedBy,
          });
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Save a post
  Future<void> savePost(String postId, String userId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'isSaved': true,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Unsave a post
  Future<void> unsavePost(String postId, String userId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'isSaved': false,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Add a comment to a post
  Future<void> addComment(String postId, String userId, String username, String content) async {
    try {
      // Add comment to comments subcollection
      await _firestore.collection('posts').doc(postId).collection('comments').add({
        'uid': userId,
        'username': username,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      // Increment comment count
      await _firestore.collection('posts').doc(postId).update({
        'comments': FieldValue.increment(1),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get comments for a post
  Stream<List<CommentModel>> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return CommentModel.fromJson(data);
      }).toList();
    });
  }

  /// Search users by username
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      return snapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
  
  /// Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? username,
    String? fullName, // Added full name parameter
    String? bio,
    String? profilePicture,
    DateTime? lastFullNameChange, // Added last full name change parameter
  }) async {
    try {
      Map<String, dynamic> updateData = {};
      
      if (username != null) updateData['username'] = username;
      if (fullName != null) updateData['fullName'] = fullName; // Added full name update
      if (bio != null) updateData['bio'] = bio;
      if (profilePicture != null) updateData['profilePicture'] = profilePicture;
      if (lastFullNameChange != null) updateData['lastFullNameChange'] = Timestamp.fromDate(lastFullNameChange); // Added last full name change update
      
      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(updateData);
      }
    } catch (e) {
      rethrow;
    }
  }
}