import 'package:cloud_firestore/cloud_firestore.dart';

/// UserModel represents a user in the application
class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? profilePicture;
  final String? bio;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.profilePicture,
    this.bio,
    this.createdAt,
  });

  /// Create a UserModel from Firestore data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      profilePicture: json['profilePicture'],
      bio: json['bio'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert UserModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'profilePicture': profilePicture,
      'bio': bio,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}