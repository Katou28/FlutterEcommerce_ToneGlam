import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:toneglam/models/cart_manager.dart";
import "package:toneglam/models/post_manager.dart";
import "package:toneglam/models/profile_manager.dart";
import "package:toneglam/login.dart";
import "package:toneglam/services/notification_service.dart";

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartManager()),
        ChangeNotifierProvider(create: (_) => PostManager()),
        ChangeNotifierProvider(create: (_) => ProfileManager()),
        ChangeNotifierProvider(create: (_) => NotificationService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToneGlam',
      theme: ThemeData(
        primaryColor: Colors.pink[300],
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: const LoginPage(),
    );
  }
}
