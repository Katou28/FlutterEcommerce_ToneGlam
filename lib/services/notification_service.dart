import 'package:flutter/material.dart' as material;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../notification.dart';

class NotificationService extends material.ChangeNotifier {
  static const String _notificationsKey = 'notifications';
  List<Notification> _notifications = [];

  List<Notification> get notifications => List.unmodifiable(_notifications);

  NotificationService() {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList(_notificationsKey);
      if (notificationsJson != null) {
        _notifications = notificationsJson
            .map((json) => Notification.fromMap(jsonDecode(json)))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = _notifications
          .map((notification) => jsonEncode(notification.toMap()))
          .toList();
      await prefs.setStringList(_notificationsKey, notificationsJson);
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }

  Future<void> addNotification(Notification notification) async {
    _notifications.insert(0, notification); // Add to the beginning
    await _saveNotifications();
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index].isRead = true;
      await _saveNotifications();
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    await _saveNotifications();
    notifyListeners();
  }

  Future<void> removeNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    await _saveNotifications();
    notifyListeners();
  }

  Future<void> addOrderNotification(String orderId, String message) async {
    final notification = Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Order Update',
      message: message,
      timestamp: DateTime.now(),
      type: NotificationType.order,
      isRead: false,
    );
    await addNotification(notification);
  }
}
