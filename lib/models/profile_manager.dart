import 'package:flutter/material.dart';

class ProfileManager extends ChangeNotifier {
  String _username = '@jessicatoneglam';
  String? _profileImagePath;

  String get username => _username;
  String? get profileImagePath => _profileImagePath;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setProfileImagePath(String? path) {
    _profileImagePath = path;
    notifyListeners();
  }
}
