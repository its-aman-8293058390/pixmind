import 'package:cloud_firestore/cloud_firestore.dart';

/// UserModel represents a user in the application
class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? fullName; // Added full name field
  final String? profilePicture;
  final String? bio;
  final DateTime? createdAt;
  final DateTime? lastFullNameChange; // Track when full name was last changed

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.fullName, // Added full name parameter
    this.profilePicture,
    this.bio,
    this.createdAt,
    this.lastFullNameChange, // Added last full name change parameter
  });

  /// Create a UserModel from Firestore data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'], // Added full name from JSON
      profilePicture: json['profilePicture'],
      bio: json['bio'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      lastFullNameChange: (json['lastFullNameChange'] as Timestamp?)?.toDate(), // Added last full name change from JSON
    );
  }

  /// Convert UserModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'fullName': fullName, // Added full name to JSON
      'profilePicture': profilePicture,
      'bio': bio,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'lastFullNameChange': lastFullNameChange != null ? Timestamp.fromDate(lastFullNameChange!) : null, // Added last full name change to JSON
    };
  }
}