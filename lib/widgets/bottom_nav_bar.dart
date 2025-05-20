import 'package:flutter/material.dart';
import 'package:toneglam/homepage.dart';
import 'package:toneglam/communityFeed.dart';
import 'package:toneglam/notification.dart';
import 'package:toneglam/cartPage.dart';
import 'package:toneglam/new_post_page.dart';
import 'package:provider/provider.dart';
import 'package:toneglam/models/post_manager.dart' as pm;
import 'package:toneglam/models/profile_manager.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final VoidCallback? onFabPressed;

  const BottomNavBar({
    Key? key,
    this.currentIndex = 0,
    this.onFabPressed,
  }) : super(key: key);

  void _navigateToPage(BuildContext context, Widget page, int index) {
    if (currentIndex != index) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.home,
                  color: currentIndex == 0 ? Colors.pink[300] : Colors.grey),
              onPressed: () => _navigateToPage(context, HomePage(), 0),
            ),
            IconButton(
              icon: Icon(Icons.people,
                  color: currentIndex == 1 ? Colors.pink[300] : Colors.grey),
              onPressed: () => _navigateToPage(context, CommunityPage(), 1),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewPostPage(
                      onPost: (image, caption) {
                        final postManager =
                            Provider.of<pm.PostManager>(context, listen: false);
                        final profileManager =
                            Provider.of<ProfileManager>(context, listen: false);
                        postManager.addPost(
                          pm.Post(
                            username: profileManager.username,
                            profileUrl: profileManager.profileImagePath ?? '',
                            imagePath: image?.path,
                            content: caption,
                            timestamp: DateTime.now(),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.pink, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(Icons.add, color: Colors.black, size: 32),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.notifications,
                  color: currentIndex == 3 ? Colors.pink[300] : Colors.grey),
              onPressed: () => _navigateToPage(context, NotificationPage(), 3),
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart,
                  color: currentIndex == 4 ? Colors.pink[300] : Colors.grey),
              onPressed: () => _navigateToPage(context, CartPage(), 4),
            ),
          ],
        ),
      ),
    );
  }
}
