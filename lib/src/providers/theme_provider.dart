import 'package:flutter/material.dart';

/// ThemeProvider manages the app's theme (light/dark mode)
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  /// Toggle between light and dark mode
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  /// Set theme to dark mode
  void setDarkMode() {
    _isDarkMode = true;
    notifyListeners();
  }

  /// Set theme to light mode
  void setLightMode() {
    _isDarkMode = false;
    notifyListeners();
  }
}