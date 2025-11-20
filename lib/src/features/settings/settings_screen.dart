import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pixmind/src/providers/auth_provider.dart';
import 'package:pixmind/src/providers/theme_provider.dart';
import 'package:pixmind/src/features/auth/login_screen.dart';

/// SettingsScreen provides user settings and logout functionality
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C63FF),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile section
            _buildSectionHeader('Profile'),
            _buildProfileOption(
              context,
              'Edit Profile',
              Icons.person_outline,
              () {
                // TODO: Implement edit profile functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Edit profile feature coming soon!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildProfileOption(
              context,
              'Change Password',
              Icons.lock_outline,
              () {
                // TODO: Implement change password functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Change password feature coming soon!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            // Preferences section
            _buildSectionHeader('Preferences'),
            _buildToggleOption(
              'Dark Mode',
              Icons.dark_mode_outlined,
              themeProvider.isDarkMode,
              (value) {
                themeProvider.toggleTheme();
              },
            ),
            _buildDivider(),
            _buildToggleOption(
              'Notifications',
              Icons.notifications_none,
              true,
              (value) {
                // TODO: Implement notifications toggle
              },
            ),
            _buildDivider(),
            _buildToggleOption(
              'Location Services',
              Icons.location_on_outlined,
              false,
              (value) {
                // TODO: Implement location services toggle
              },
            ),
            SizedBox(height: 20),
            // Support section
            _buildSectionHeader('Support'),
            _buildSimpleOption(
              context,
              'Help & Support',
              Icons.help_outline,
              () {
                // TODO: Implement help & support
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Help & support feature coming soon!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildSimpleOption(
              context,
              'Privacy Policy',
              Icons.privacy_tip_outlined,
              () {
                // TODO: Implement privacy policy
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Privacy policy feature coming soon!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildSimpleOption(
              context,
              'Terms of Service',
              Icons.description_outlined,
              () {
                // TODO: Implement terms of service
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Terms of service feature coming soon!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            // Account section
            _buildSectionHeader('Account'),
            _buildSimpleOption(
              context,
              'Logout',
              Icons.logout_outlined,
              () {
                _showLogoutConfirmationDialog(context, authProvider);
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  /// Build section header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  /// Build profile option with avatar
  Widget _buildProfileOption(BuildContext context, String title, IconData icon,
      VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF6C63FF)),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // User avatar placeholder
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Icon(
              Icons.person,
              size: 15,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  /// Build toggle option
  Widget _buildToggleOption(
      String title, IconData icon, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF6C63FF)),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xFF6C63FF),
      ),
    );
  }

  /// Build divider
  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 20,
      endIndent: 20,
      color: Colors.grey[300],
    );
  }

  /// Build simple option
  Widget _buildSimpleOption(BuildContext context, String title, IconData icon,
      VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Color(0xFF6C63FF)),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutConfirmationDialog(
      BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await authProvider.signOut();
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}