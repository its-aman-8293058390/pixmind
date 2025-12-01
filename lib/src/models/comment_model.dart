import 'package:cloud_firestore/cloud_firestore.dart';

/// CommentModel represents a comment on a post
class CommentModel {
  final String id;
  final String uid;
  final String username;
  final String content;
  final DateTime timestamp;

  CommentModel({
    required this.id,
    required this.uid,
    required this.username,
    required this.content,
    required this.timestamp,
  });

  /// Create a CommentModel from Firestore data
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      content: json['content'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  /// Convert CommentModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'username': username,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}