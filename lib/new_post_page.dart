import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toneglam/communityFeed.dart';

class NewPostPage extends StatefulWidget {
  final Function(File? image, String caption) onPost;

  const NewPostPage({required this.onPost, Key? key}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  File? _image;
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _captionController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void _submit() {
    if (_image != null || _captionController.text.trim().isNotEmpty) {
      widget.onPost(_image, _captionController.text.trim());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CommunityPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        backgroundColor: Colors.pink[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _image == null
                  ? Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.add_a_photo,
                          size: 48, color: Colors.pink[300]),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(_image!,
                          width: 140, height: 140, fit: BoxFit.cover),
                    ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed:
                  _captionController.text.trim().isNotEmpty || _image != null
                      ? _submit
                      : null,
              icon: Icon(Icons.send),
              label: Text('Post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[300],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
