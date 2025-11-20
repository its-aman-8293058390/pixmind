import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pixmind/src/providers/auth_provider.dart';
import 'package:pixmind/src/features/onboarding/onboarding_screen.dart';
import 'package:pixmind/src/features/home/home_screen.dart';

/// SplashScreen shows the app logo with smooth animations
/// and redirects to appropriate screen based on auth state
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    // Start animation
    _controller.forward();
    
    // Navigate to next screen after delay
    _navigateToNextScreen();
  }

  /// Navigate to appropriate screen based on auth state
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6C63FF), // Primary brand color
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo (using text for now, can be replaced with actual logo)
                Icon(
                  Icons.camera_alt_outlined,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  'Pix Mind',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Arial', // Can be customized with custom font
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Connect. Share. Feel the Vibe.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 40),
                // Loading indicator
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}