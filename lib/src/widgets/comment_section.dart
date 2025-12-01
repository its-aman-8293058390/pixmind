import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pixmind/src/providers/post_provider.dart';
import 'package:pixmind/src/providers/auth_provider.dart';
import 'package:pixmind/src/models/comment_model.dart';

/// CommentSection displays comments for a post and allows adding new comments
class CommentSection extends StatefulWidget {
  final String postId;
  
  const CommentSection({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  List<CommentModel> _comments = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  /// Load comments for the post
  void _loadComments() {
    setState(() {
      _isLoading = true;
    });
    
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.getComments(widget.postId).listen((comments) {
      if (mounted) {
        setState(() {
          _comments = comments;
          _isLoading = false;
        });
      }
    });
  }

  /// Add a new comment
  void _addComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    
    if (authProvider.user == null) return;
    
    try {
      await postProvider.addComment(
        widget.postId,
        authProvider.user!.uid,
        authProvider.user!.username,
        content,
      );
      
      // Clear the input field
      _commentController.clear();
      
      // Reload comments to show the new one
      _loadComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add comment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comments list
        if (_isLoading)
          Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          ..._comments.map((comment) => _buildCommentItem(comment)).toList(),
        
        // Add comment input
        _buildAddCommentInput(),
      ],
    );
  }

  /// Build a single comment item
  Widget _buildCommentItem(CommentModel comment) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Icon(
              Icons.person,
              size: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 10),
          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and content
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: '${comment.username} ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: comment.content,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                // Timestamp
                Text(
                  _formatTimestamp(comment.timestamp),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build the add comment input field
  Widget _buildAddCommentInput() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // User avatar
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Icon(
              Icons.person,
              size: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 10),
          // Input field
          Expanded(
            child: TextField(
              controller: _commentController,
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
              onSubmitted: (_) => _addComment(),
            ),
          ),
          // Post button
          TextButton(
            onPressed: _addComment,
            child: Text(
              'Post',
              style: TextStyle(
                color: Color(0xFF6C63FF),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Format timestamp for display
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Just now';
    }
  }
}