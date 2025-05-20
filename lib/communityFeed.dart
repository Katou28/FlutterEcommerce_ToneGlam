import 'package:flutter/material.dart';
import 'package:toneglam/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:toneglam/models/post_manager.dart' as pm;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CommunityPage extends StatefulWidget {
  final bool openNewPostDialog;
  const CommunityPage({Key? key, this.openNewPostDialog = false})
      : super(key: key);
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<String> userAvatars = [
    'assets/RandomUser/1.png',
    'assets/RandomUser/2.png',
    'assets/RandomUser/3.png',
    'assets/RandomUser/4.png',
    'assets/RandomUser/5.png',
  ];

  Future<void> _refreshPosts() async {
    await Future.delayed(Duration(seconds: 1));
    if (!mounted) return;
    setState(() {}); // In real app, fetch new posts
  }

  void _showNewPostDialog() {
    showDialog(
      context: context,
      builder: (context) => NewPostDialog(
        onPost: (File image, String caption) {
          setState(() {
            // Add new post logic here
          });
        },
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  void initState() {
    super.initState();
    if (widget.openNewPostDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNewPostDialog();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = context.watch<pm.PostManager>().posts;
    return Scaffold(
      appBar: AppBar(
        title: Text('Community', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.pink[300]),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: userAvatars.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.pink[300],
                        backgroundImage: AssetImage(userAvatars[index]),
                        child: userAvatars[index].isEmpty
                            ? Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      if (index == 0)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildPostCard(post, index),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildPostCard(pm.Post post, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.pink[300],
                  backgroundImage: post.profileUrl.startsWith('assets/')
                      ? AssetImage(post.profileUrl) as ImageProvider
                      : NetworkImage(post.profileUrl),
                ),
                SizedBox(width: 8),
                Text(post.username,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                Text(_timeAgo(post.timestamp),
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                SizedBox(width: 8),
                Icon(Icons.more_vert),
              ],
            ),
          ),
          if (post.imagePath != null && post.imagePath!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: post.imagePath!.startsWith('assets/')
                  ? Image.asset(
                      post.imagePath!,
                      fit: BoxFit.cover,
                      height: 180,
                      width: double.infinity,
                    )
                  : Image.file(
                      File(post.imagePath!),
                      fit: BoxFit.cover,
                      height: 180,
                      width: double.infinity,
                    ),
            ),
          if (post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Text(post.content),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.red : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      post.isLiked = !post.isLiked;
                      post.likes += post.isLiked ? 1 : -1;
                    });
                  },
                ),
                Text('${post.likes}'),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.comment_outlined),
                  onPressed: () {},
                ),
                Text('${post.comments}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewPostDialog extends StatefulWidget {
  final Function(File image, String caption) onPost;
  const NewPostDialog({required this.onPost, Key? key}) : super(key: key);

  @override
  _NewPostDialogState createState() => _NewPostDialogState();
}

class _NewPostDialogState extends State<NewPostDialog> {
  File? _image;
  final TextEditingController _captionController = TextEditingController();

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Post'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _image == null
                  ? Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[200],
                      child: Icon(Icons.add_a_photo, size: 40),
                    )
                  : Image.file(_image!,
                      width: 120, height: 120, fit: BoxFit.cover),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(hintText: 'Write a caption...'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _image != null && _captionController.text.trim().isNotEmpty
              ? () {
                  widget.onPost(_image!, _captionController.text.trim());
                  Navigator.pop(context);
                }
              : null,
          child: Text('Post'),
        ),
      ],
    );
  }
}
