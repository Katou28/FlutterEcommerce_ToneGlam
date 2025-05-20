import 'package:flutter/material.dart';
import 'package:toneglam/login.dart';
import 'package:toneglam/widgets/bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:toneglam/models/profile_manager.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final String _displayName = 'Jessica Smith';

  String _coverImageUrl =
      'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    _usernameController.text = '@jessicatoneglam';
    _bioController.text = 'Makeup artist & beauty enthusiast 💄\n'
        'Creating content to help you feel your best!\n'
        '📍 New York City';
  }

  Future<void> _pickProfileImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        Provider.of<ProfileManager>(context, listen: false)
            .setProfileImagePath(picked.path);
      }
    } catch (e) {
      if (e.toString().contains('already_active')) {
        // If picker is already active, just return
        return;
      }
      // Show error message for other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileManager = Provider.of<ProfileManager>(context);
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildProfileBody(profileManager),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Profile',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.black),
          onPressed: () => _showSettings(),
        ),
        _buildLogoutButton(),
      ],
    );
  }

  Widget _buildProfileBody(ProfileManager profileManager) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(profileManager),
          _buildUserInfo(profileManager),
          _buildStatsRow(),
          _buildActionButtons(),
          _buildBioSection(),
          _buildPostsGrid(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ProfileManager profileManager) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(_coverImageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.pink[100],
                backgroundImage: profileManager.profileImagePath != null
                    ? FileImage(File(profileManager.profileImagePath!))
                    : null,
                child: profileManager.profileImagePath == null
                    ? Icon(Icons.person, size: 50, color: Colors.pink[300])
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(ProfileManager profileManager) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          Text(
            _displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => _editUsername(profileManager),
            child: Text(
              profileManager.username,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _StatItem(value: '142', label: 'Posts'),
          _StatItem(value: '2.5K', label: 'Followers'),
          _StatItem(value: '896', label: 'Following'),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[300],
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () => _editBio(),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Share'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
                foregroundColor: Colors.black87,
                backgroundColor: Colors.grey[200],
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                // Add share functionality
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[300],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => _editBio(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _bioController.text,
            style:
                const TextStyle(fontSize: 16, height: 1.5, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            'My Posts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink[300],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 9,
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://picsum.photos/200?random=$index',
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Account Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to account settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to notifications settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to privacy settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to help & support
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editUsername(ProfileManager profileManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Username'),
        content: TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            hintText: 'Enter your username',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_usernameController.text.isNotEmpty) {
                profileManager.setUsername(_usernameController.text);
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editBio() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Bio'),
        content: TextField(
          controller: _bioController,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'Enter your bio'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_bioController.text.isNotEmpty) {
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return IconButton(
      icon: const Icon(Icons.logout, color: Colors.red),
      onPressed: () => _confirmLogout(),
      tooltip: 'Log Out',
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Navigate to LoginPage and clear the navigation stack
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false, // Remove all previous routes
              );
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.pink[300],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
