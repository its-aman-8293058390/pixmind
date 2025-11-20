/// App constants and theme definitions
class AppConstants {
  // App name and slogan
  static const String appName = 'Pix Mind';
  static const String appSlogan = 'Connect. Share. Feel the Vibe.';
  
  // Colors
  static const int primaryColor = 0xFF6C63FF;
  static const int secondaryColor = 0xFF4A44B5;
  static const int accentColor = 0xFFFF6584;
  
  // Firestore collection names
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  
  // Validation regex
  static final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  
  // App limits
  static const int maxPostLength = 500;
  static const int minPasswordLength = 6;
  static const int minUsernameLength = 3;
}