# Pix Mind

**Connect. Share. Feel the Vibe.**

Pix Mind is a modern social media web application built with Flutter and Firebase. It allows users to connect with friends, share posts, and explore content in a beautifully designed interface.

## Features

- 🎨 Premium and modern UI design
- 🔐 Firebase Authentication (Email & Password)
- ☁️ Cloud Firestore for data storage
- 📱 Fully responsive layout
- 🌟 Clean architecture with MVVM pattern
- 🔄 Real-time updates

## Screens

1. **Splash Screen** - Smooth animation with app logo
2. **Onboarding Screen** - 3 sliding pages with illustrations
3. **Login Screen** - Email/password validation
4. **Signup Screen** - Username, email, password validation
5. **Home Feed Screen** - Dynamic posts from Firestore
6. **User Profile Screen** - User info and posts
7. **Add Post Screen** - Text post creation
8. **Search Screen** - Search users and view profiles
9. **Settings Screen** - Logout and profile editing

## Technology Stack

- **Frontend**: Flutter Web
- **State Management**: Provider
- **Backend**: Firebase (Authentication & Cloud Firestore)
- **Architecture**: Clean Architecture with MVVM pattern

## Folder Structure

```
lib/
├── src/
│   ├── core/
│   ├── features/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── profile/
│   │   ├── search/
│   │   ├── settings/
│   │   ├── onboarding/
│   │   └── post/
│   ├── providers/
│   ├── models/
│   ├── services/
│   └── utils/
├── main.dart
└── firebase_options.dart
```

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Set up Firebase project and add your configuration
4. Run `flutter run -d chrome`

## Firebase Configuration

The app uses Firebase for authentication and data storage. Make sure to:

1. Create a Firebase project
2. Enable Email/Password authentication
3. Set up Cloud Firestore
4. Add your Firebase configuration to `lib/firebase_options.dart`

## Security Rules

Firestore security rules are defined in `firebase/firestore.rules` to ensure:

- Users can only read public data
- Users can only modify their own data
- Proper data validation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.