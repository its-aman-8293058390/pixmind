import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pixmind/src/providers/auth_provider.dart';
import 'package:pixmind/src/providers/post_provider.dart';
import 'package:pixmind/src/models/post_model.dart';

/// ReelsScreen displays short video content similar to Instagram Reels
class ReelsScreen extends StatefulWidget {
  @override
  _ReelsScreenState createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Initialize post provider to load reels
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      postProvider.loadReels();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reels',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C63FF),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: postProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : postProvider.reels.isEmpty
              ? _buildEmptyState()
              : PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: postProvider.reels.length,
                  itemBuilder: (context, index) {
                    return _buildReelItem(
                        postProvider.reels[index], authProvider, postProvider);
                  },
                ),
    );
  }

  /// Build empty state when no reels
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.slow_motion_video_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'No reels yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Check back later for new reels',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Build a single reel item
  Widget _buildReelItem(
      PostModel reel, AuthProvider authProvider, PostProvider postProvider) {
    final isLiked = reel.likedBy.contains(authProvider.user?.uid ?? '');
    final isSaved = reel.isSaved;

    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Video placeholder (in a real app, this would be a video player)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[900],
            child: Center(
              child: Icon(
                Icons.play_arrow,
                size: 100,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          // Gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          // Reel info
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and description
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        reel.username,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Reel description
                if (reel.content.isNotEmpty)
                  Text(
                    reel.content,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                SizedBox(height: 15),
                // Action buttons
                Row(
                  children: [
                    // Like button
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            _handleLikeReel(reel, authProvider, postProvider);
                          },
                        ),
                        Text(
                          '${reel.likes}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    // Comment button
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.comment_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
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
                        Text(
                          '${reel.comments}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    // Share button
                    IconButton(
                      icon: Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
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
                    // Save button
                    IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? Colors.white : Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        _handleSaveReel(reel, authProvider, postProvider);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Handle like/unlike reel
  void _handleLikeReel(
      PostModel reel, AuthProvider authProvider, PostProvider postProvider) {
    if (authProvider.user == null) return;

    final isLiked = reel.likedBy.contains(authProvider.user!.uid);

    if (isLiked) {
      postProvider.unlikePost(reel.id, authProvider.user!.uid);
    } else {
      postProvider.likePost(reel.id, authProvider.user!.uid);
    }
  }

  /// Handle save/unsave reel
  void _handleSaveReel(
      PostModel reel, AuthProvider authProvider, PostProvider postProvider) {
    if (authProvider.user == null) return;

    final isSaved = reel.isSaved;

    if (isSaved) {
      postProvider.unsavePost(reel.id, authProvider.user!.uid);
    } else {
      postProvider.savePost(reel.id, authProvider.user!.uid);
    }
  }
}