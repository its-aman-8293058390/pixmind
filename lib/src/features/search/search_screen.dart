import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pixmind/src/providers/search_provider.dart';
import 'package:pixmind/src/models/user_model.dart';
import 'package:pixmind/src/features/profile/profile_screen.dart'; // Import profile screen

/// SearchScreen allows users to search for other users
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize search provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchProvider = Provider.of<SearchProvider>(context, listen: false);
      searchProvider.searchUsers('');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C63FF),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                final searchProvider =
                    Provider.of<SearchProvider>(context, listen: false);
                searchProvider.searchUsers(value);
              },
              decoration: InputDecoration(
                hintText: 'Search users by username or EId...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          // Search results
          Expanded(
            child: searchProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : searchProvider.searchResults.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemCount: searchProvider.searchResults.length,
                        itemBuilder: (context, index) {
                          return _buildUserCard(
                              searchProvider.searchResults[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  /// Build empty state when no search results
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 60,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'Search for users',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Enter a username or EId to find people',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Build a user card
  Widget _buildUserCard(UserModel user) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        leading: Container(
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
        title: Text(
          user.fullName != null && user.fullName!.isNotEmpty 
              ? '${user.fullName} (${user.username})' 
              : user.username,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          user.email,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: OutlinedButton(
          onPressed: () {
            // TODO: Implement follow/unfollow functionality
          },
          child: Text('Follow'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Color(0xFF6C63FF)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onTap: () {
          // Navigate to user's profile when tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileViewScreen(user: user),
            ),
          );
        },
      ),
    );
  }
}