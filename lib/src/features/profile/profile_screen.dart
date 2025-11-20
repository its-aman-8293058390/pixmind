import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pixmind/src/providers/auth_provider.dart';
import 'package:pixmind/src/providers/post_provider.dart';
import 'package:pixmind/src/models/post_model.dart';

/// ProfileScreen displays user profile and their posts
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load user posts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      if (authProvider.user != null) {
        postProvider.loadUserPosts(authProvider.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);
    
    if (authProvider.user == null) {
      return Center(child: CircularProgressIndicator());
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C63FF),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Color(0xFF6C63FF)),
            onPressed: () {
              _showEditProfileModal(context, authProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          postProvider.loadUserPosts(authProvider.user!.uid);
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile header
              _buildProfileHeader(authProvider),
              SizedBox(height: 20),
              // User stats
              _buildUserStats(),
              SizedBox(height: 20),
              // User posts
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Your Posts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Posts list
              postProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : postProvider.posts.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(50),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.post_add_outlined,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'No posts yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Share your first post!',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: postProvider.posts.length,
                          itemBuilder: (context, index) {
                            return _buildPostCard(postProvider.posts[index]);
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show edit profile modal
  void _showEditProfileModal(BuildContext context, AuthProvider authProvider) {
    final _formKey = GlobalKey<FormState>();
    final _usernameController = TextEditingController(text: authProvider.user!.username);
    final _bioController = TextEditingController(text: authProvider.user!.bio);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Profile picture
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF6C63FF),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // Username field
                Text(
                  'Username',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Enter username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Bio field
                Text(
                  'Bio',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tell us about yourself',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        
                        try {
                          await authProvider.updateUserProfile(
                            username: _usernameController.text.trim(),
                            bio: _bioController.text.trim(),
                          );
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Profile updated successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to update profile: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build profile header with user info
  Widget _buildProfileHeader(AuthProvider authProvider) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile picture
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 20),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authProvider.user!.username,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  authProvider.user!.email,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                if (authProvider.user!.bio != null &&
                    authProvider.user!.bio!.isNotEmpty)
                  Text(
                    authProvider.user!.bio!,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build user statistics
  Widget _buildUserStats() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Posts', '25'),
          _buildStatItem('Followers', '1.2K'),
          _buildStatItem('Following', '350'),
        ],
      ),
    );
  }

  /// Build a single stat item
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Build a post card
  Widget _buildPostCard(PostModel post) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post content
            Text(
              post.content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            SizedBox(height: 15),
            // Post timestamp
            Text(
              _formatTimestamp(post.timestamp),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Format timestamp for display
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}