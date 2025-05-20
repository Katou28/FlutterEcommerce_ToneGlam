import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:toneglam/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:toneglam/services/notification_service.dart';

class NotificationPage extends material.StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends material.State<NotificationPage> {
  @override
  material.Widget build(material.BuildContext context) {
    return material.Scaffold(
      appBar: material.AppBar(
        title: const material.Text(
          'Notifications',
          style: material.TextStyle(
            color: material.Colors.black,
            fontWeight: material.FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: material.Colors.white,
        elevation: 1,
        actions: [
          material.TextButton(
            onPressed: () {
              Provider.of<NotificationService>(context, listen: false)
                  .markAllAsRead();
            },
            child: material.Text(
              'Mark all as read',
              style: material.TextStyle(
                  color: material.Colors.pink[300], fontSize: 14),
            ),
          ),
        ],
      ),
      body: Consumer<NotificationService>(
        builder: (context, notificationService, child) {
          final notifications = notificationService.notifications;

          return notifications.isEmpty
              ? _buildEmptyState()
              : material.ListView.builder(
                  padding: const material.EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return material.Dismissible(
                      key: material.Key(notification.id),
                      background:
                          material.Container(color: material.Colors.red),
                      onDismissed: (direction) {
                        notificationService.removeNotification(notification.id);
                      },
                      child: _buildNotificationCard(notification),
                    );
                  },
                );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  material.Widget _buildNotificationCard(Notification notification) {
    return material.Card(
      margin: const material.EdgeInsets.only(bottom: 12),
      shape: material.RoundedRectangleBorder(
          borderRadius: material.BorderRadius.circular(12)),
      elevation: 2,
      color: notification.isRead
          ? material.Colors.white
          : material.Colors.pink[50],
      child: material.ListTile(
        contentPadding: const material.EdgeInsets.all(16),
        leading: _getNotificationIcon(notification.type),
        title: material.RichText(
          text: material.TextSpan(
            style: material.TextStyle(
              color: material.Colors.black87,
              fontWeight: notification.isRead
                  ? material.FontWeight.normal
                  : material.FontWeight.bold,
            ),
            children: [
              if (notification.actor != null)
                material.TextSpan(
                  text: '${notification.actor} ',
                  style: material.TextStyle(
                    color: material.Colors.pink[300],
                    fontWeight: material.FontWeight.bold,
                  ),
                ),
              material.TextSpan(text: notification.message),
            ],
          ),
        ),
        subtitle: material.Column(
          crossAxisAlignment: material.CrossAxisAlignment.start,
          children: [
            if (notification.type == NotificationType.social &&
                notification.postId != null)
              material.TextButton(
                onPressed: () => _viewPost(notification.postId!),
                child: const material.Text(
                  'View Post',
                  style: material.TextStyle(
                      color: material.Colors.pink, fontSize: 12),
                ),
              ),
            material.Text(
              DateFormat(
                'MMM dd, yyyy - hh:mm a',
              ).format(notification.timestamp),
              style: material.TextStyle(
                  color: material.Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        onTap: () => _handleNotificationTap(notification),
      ),
    );
  }

  material.Widget _getNotificationIcon(NotificationType type) {
    material.IconData icon;
    material.Color color = material.Colors.pink[300]!;

    switch (type) {
      case NotificationType.order:
        icon = material.Icons.local_shipping;
        break;
      case NotificationType.promotion:
        icon = material.Icons.tag;
        break;
      case NotificationType.system:
        icon = material.Icons.info_outline;
        break;
      case NotificationType.social:
        icon = material.Icons.favorite;
        color = material.Colors.red;
        break;
    }

    return material.CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: material.Icon(icon, color: color),
    );
  }

  material.Widget _buildEmptyState() {
    return material.Center(
      child: material.Column(
        mainAxisAlignment: material.MainAxisAlignment.center,
        children: [
          material.Icon(material.Icons.notifications_off,
              size: 64, color: material.Colors.grey[400]),
          const material.SizedBox(height: 16),
          const material.Text(
            'No notifications yet',
            style:
                material.TextStyle(fontSize: 18, color: material.Colors.grey),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(Notification notification) {
    Provider.of<NotificationService>(context, listen: false)
        .markAsRead(notification.id);

    switch (notification.type) {
      case NotificationType.order:
        // Navigate to order details
        break;
      case NotificationType.promotion:
        // Navigate to promotions page
        break;
      case NotificationType.system:
        // Show system message dialog
        break;
      case NotificationType.social:
        if (notification.postId != null) {
          _viewPost(notification.postId!);
        }
        break;
    }
  }

  void _viewPost(String postId) {
    material.Navigator.push(
      context,
      material.MaterialPageRoute(
          builder: (context) => PostDetailPage(postId: postId)),
    );
  }
}

enum NotificationType { order, promotion, system, social }

class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;
  final String? actor;
  final String? postId;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.type = NotificationType.system,
    this.isRead = false,
    this.actor,
    this.postId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString(),
      'isRead': isRead,
      'actor': actor,
      'postId': postId,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => NotificationType.system,
      ),
      isRead: map['isRead'],
      actor: map['actor'],
      postId: map['postId'],
    );
  }
}

class PostDetailPage extends material.StatelessWidget {
  final String postId;

  const PostDetailPage({required this.postId});

  @override
  material.Widget build(material.BuildContext context) {
    return material.Scaffold(
      appBar: material.AppBar(title: material.Text('Post $postId')),
      body: material.Center(child: material.Text('Details for post $postId')),
    );
  }
}
