import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pixmind/src/providers/auth_provider.dart';
import 'package:pixmind/src/providers/post_provider.dart';
import 'package:image_picker/image_picker.dart'; // Added image picker
import 'dart:io'; // Added for file handling

/// AddPostScreen allows users to create new text posts or reels
class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  String? _errorMessage;
  XFile? _selectedImage; // Changed to XFile for image picker
  XFile? _selectedVideo; // Changed to XFile for image picker
  bool _isCreatingReel = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  /// Handle post submission
  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      
      try {
        await postProvider.createPost(
          uid: authProvider.user!.uid,
          username: authProvider.user!.username,
          content: _contentController.text.trim(),
          imageUrl: _isCreatingReel ? null : _selectedImage?.path, // Updated to use path
          videoUrl: _isCreatingReel ? _selectedVideo?.path : null, // Updated to use path
        );
        
        // Clear the form
        _contentController.clear();
        setState(() {
          _selectedImage = null;
          _selectedVideo = null;
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isCreatingReel ? 'Reel created successfully!' : 'Post created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back to home
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  /// Select an image from gallery
  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Select a video from gallery
  Future<void> _selectVideo() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _selectedVideo = video;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick video: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isCreatingReel ? 'Create Reel' : 'Create Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C63FF),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Consumer<PostProvider>(
            builder: (context, postProvider, child) {
              return TextButton(
                onPressed: postProvider.isLoading ? null : _handleSubmit,
                child: Text(
                  'Post',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Toggle between post and reel
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isCreatingReel = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCreatingReel ? Colors.grey[300] : Color(0xFF6C63FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: _isCreatingReel ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isCreatingReel = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCreatingReel ? Color(0xFF6C63FF) : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Reel',
                        style: TextStyle(
                          color: _isCreatingReel ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Error message
              if (_errorMessage != null)
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
              // User info
              Row(
                children: [
                  // Profile picture placeholder
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: Icon(
                      Icons.person,
                      size: 25,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.user?.username ?? 'User',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Public',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Media selection
              if (_isCreatingReel)
                _buildVideoSelection()
              else
                _buildImageSelection(),
              SizedBox(height: 20),
              // Post content field
              TextFormField(
                controller: _contentController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: _isCreatingReel ? 'Add a caption...' : 'What\'s on your mind?',
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content for your post';
                  }
                  if (value.length > 500) {
                    return 'Post content cannot exceed 500 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Character counter
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${_contentController.text.length}/500',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build image selection UI
  Widget _buildImageSelection() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: _selectedImage != null
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(_selectedImage!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.add_a_photo, size: 50, color: Colors.grey[600]),
                  onPressed: _selectImage,
                ),
                Text(
                  'Add Photo',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
    );
  }

  /// Build video selection UI
  Widget _buildVideoSelection() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: _selectedVideo != null
          ? Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  Icons.play_arrow,
                  size: 100,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.video_call, size: 50, color: Colors.grey[600]),
                  onPressed: _selectVideo,
                ),
                Text(
                  'Add Video',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
    );
  }
}