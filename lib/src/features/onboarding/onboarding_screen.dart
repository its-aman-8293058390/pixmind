import 'package:flutter/material.dart';
import 'package:pixmind/src/features/auth/login_screen.dart';

/// OnboardingScreen shows 3 sliding pages with illustrations
class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingPages = [
    {
      'title': 'Connect with Friends',
      'description': 'Find and connect with friends from around the world',
      'image': 'assets/images/onboarding1.png', // Placeholder
    },
    {
      'title': 'Share Your Moments',
      'description': 'Share your photos and experiences with your followers',
      'image': 'assets/images/onboarding2.png', // Placeholder
    },
    {
      'title': 'Feel the Vibe',
      'description': 'Experience a whole new way of social networking',
      'image': 'assets/images/onboarding3.png', // Placeholder
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingPages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildOnboardingPage(_onboardingPages[index]);
            },
          ),
          // Skip button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Color(0xFF6C63FF),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Page indicators
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingPages.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Color(0xFF6C63FF)
                        : Colors.grey.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          // Next/Get Started button
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage == _onboardingPages.length - 1) {
                    // Navigate to login screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  } else {
                    // Move to next page
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _currentPage == _onboardingPages.length - 1
                      ? 'Get Started'
                      : 'Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a single onboarding page
  Widget _buildOnboardingPage(Map<String, String> pageData) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration (placeholder)
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.image,
              size: 100,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 50),
          Text(
            pageData['title']!,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            pageData['description']!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}