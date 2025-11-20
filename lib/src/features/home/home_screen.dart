import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pixmind/src/providers/auth_provider.dart';
import 'package:pixmind/src/providers/post_provider.dart';
import 'package:pixmind/src/models/post_model.dart';
import 'package:pixmind/src/features/post/add_post_screen.dart';
import 'package:pixmind/src/features/search/search_screen.dart';
import 'package:pixmind/src/features/profile/profile_screen.dart';
import 'package:pixmind/src/features/settings/settings_screen.dart';
import 'package:pixmind/src/features/reels/reels_screen.dart';

/// HomeScreen displays the main feed with all posts
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeFeedScreen(),
    SearchScreen(),
    AddPostScreen(),
    ReelsScreen(), // Changed from ProfileScreen to ReelsScreen
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize post provider to load posts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      postProvider.loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.slow_motion_video_outlined),
            activeIcon: Icon(Icons.slow_motion_video),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

/// HomeFeedScreen displays the actual feed of posts
class HomeFeedScreen extends StatefulWidget {
  @override
  _HomeFeedScreenState createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pix Mind',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C63FF),
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.camera_alt, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            // TODO: Implement camera functionality
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.send, color: Theme.of(context).iconTheme.color),
            onPressed: () {
              // TODO: Implement direct messages
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          postProvider.loadPosts();
        },
        child: postProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  // Stories section
                  _buildStoriesSection(),
                  // Posts
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(0),
                    itemCount: postProvider.posts.length,
                    itemBuilder: (context, index) {
                      return _buildPostCard(postProvider.posts[index], authProvider, postProvider);
                    },
                  ),
                ],
              ),
      ),
    );
  }

  /// Build stories section
  Widget _buildStoriesSection() {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Your story
          _buildStoryItem('Your Story', true),
          // Other stories
          _buildStoryItem('john_doe', false),
          _buildStoryItem('jane_smith', false),
          _buildStoryItem('alex_wilson', false),
          _buildStoryItem('sarah_jones', false),
          _buildStoryItem('mike_brown', false),
        ],
      ),
    );
  }

  /// Build a story item
  Widget _buildStoryItem(String username, bool isOwnStory) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isOwnStory
                  ? LinearGradient(
                      colors: [Colors.grey, Colors.grey],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : LinearGradient(
                      colors: [Color(0xFF405DE6), Color(0xFF5851DB), Color(0xFF833AB4), Color(0xFFC13584), Color(0xFFE1306C), Color(0xFFF77737), Color(0xFFFCAF45)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
            ),
            child: Container(
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  isOwnStory ? Icons.add : Icons.person,
                  size: 30,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            username.length > 10 ? '${username.substring(0, 7)}...' : username,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  /// Build a post card widget
  Widget _buildPostCard(PostModel post, AuthProvider authProvider, PostProvider postProvider) {
    final isLiked = post.likedBy.contains(authProvider.user?.uid ?? '');
    final isSaved = post.isSaved;
    
    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                // Profile picture
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    Text(
                      _formatTimestamp(post.timestamp),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    // TODO: Implement post options
                  },
                ),
              ],
            ),
          ),
          // Post content with double tap to like
          GestureDetector(
            onDoubleTap: () {
              _handleLikePost(post, authProvider, postProvider);
            },
            child: Container(
              height: 400,
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  post.videoUrl != null ? Icons.play_arrow : Icons.image,
                  size: 100,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          // Post actions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    _handleLikePost(post, authProvider, postProvider);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.comment_outlined, color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    // TODO: Implement comment functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Comment feature coming soon!'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send_outlined, color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    // TODO: Implement share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Share feature coming soon!'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Theme.of(context).iconTheme.color : Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    _handleSavePost(post, authProvider, postProvider);
                  },
                ),
              ],
            ),
          ),
          // Likes count
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${post.likes} likes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          SizedBox(height: 5),
          // Post caption
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 14,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: '${post.username} ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: post.content,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5),
          // View all comments
          if (post.comments > 0)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'View all ${post.comments} comments',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          SizedBox(height: 5),
          // Add comment
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        postProvider.addComment(
                          post.id,
                          authProvider.user!.uid,
                          authProvider.user!.username,
                          value.trim(),
                        );
                      }
                    },
                  ),
                ),
                Text(
                  'Post',
                  style: TextStyle(
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  /// Handle like/unlike post
  void _handleLikePost(PostModel post, AuthProvider authProvider, PostProvider postProvider) {
    if (authProvider.user == null) return;
    
    final isLiked = post.likedBy.contains(authProvider.user!.uid);
    
    if (isLiked) {
      postProvider.unlikePost(post.id, authProvider.user!.uid);
    } else {
      postProvider.likePost(post.id, authProvider.user!.uid);
      // Show like animation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Liked!'),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  /// Handle save/unsave post
  void _handleSavePost(PostModel post, AuthProvider authProvider, PostProvider postProvider) {
    if (authProvider.user == null) return;
    
    final isSaved = post.isSaved;
    
    if (isSaved) {
      postProvider.unsavePost(post.id, authProvider.user!.uid);
    } else {
      postProvider.savePost(post.id, authProvider.user!.uid);
    }
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