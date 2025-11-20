import 'package:cloud_firestore/cloud_firestore.dart';

/// PostModel represents a post in the application
class PostModel {
  final String id;
  final String uid;
  final String username;
  final String content;
  final String? imageUrl;
  final String? videoUrl;
  final DateTime timestamp;
  final int likes;
  final int comments;
  final List<String> likedBy;
  final bool isSaved;

  PostModel({
    required this.id,
    required this.uid,
    required this.username,
    required this.content,
    this.imageUrl,
    this.videoUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.likedBy,
    required this.isSaved,
  });

  /// Create a PostModel from Firestore data
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
      isSaved: json['isSaved'] ?? false,
    );
  }

  /// Convert PostModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'username': username,
      'content': content,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'comments': comments,
      'likedBy': likedBy,
      'isSaved': isSaved,
    };
  }
}