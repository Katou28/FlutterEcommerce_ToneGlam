import 'package:flutter/material.dart';

class Post {
  final String username;
  final String profileUrl;
  final String? imagePath;
  final String content;
  final DateTime timestamp;
  int likes;
  int comments;
  bool isLiked;

  Post({
    required this.username,
    required this.profileUrl,
    this.imagePath,
    required this.content,
    required this.timestamp,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });
}

class PostManager extends ChangeNotifier {
  final List<Post> _posts = [
    Post(
      username: '@makeuplover',
      profileUrl: 'assets/RandomUser/1.png',
      imagePath: 'assets/RandomUser/1.png',
      content:
          'Loving this new rose gold eyeshadow palette! 😍 #makeup #beauty',
      timestamp: DateTime.now().subtract(Duration(minutes: 10)),
      likes: 12,
      comments: 3,
    ),
    Post(
      username: '@skincarefan',
      profileUrl: 'assets/RandomUser/2.png',
      imagePath: 'assets/RandomUser/2.png',
      content:
          'Just tried the new hydrating serum and my skin feels amazing! ✨ #skincare',
      timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 5)),
      likes: 8,
      comments: 1,
    ),
  ];

  List<Post> get posts => List.unmodifiable(_posts);

  void addPost(Post post) {
    _posts.insert(0, post);
    notifyListeners();
  }
}
