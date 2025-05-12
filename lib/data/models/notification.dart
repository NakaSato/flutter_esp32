import 'package:flutter/material.dart';

enum NotificationType {
  alert, // For critical alerts
  warning, // For warnings
  info, // For informational notifications
  success, // For success messages
}

class Notification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final String? deviceId; // Optional related device
  final String? roomId; // Optional related room
  final IconData icon;
  bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.deviceId,
    this.roomId,
    required this.icon,
    this.isRead = false,
  });

  // Returns appropriate color based on notification type
  Color getColor() {
    switch (type) {
      case NotificationType.alert:
        return Colors.red;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.success:
        return Colors.green;
    }
  }

  // Clone with some properties changed
  Notification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    String? deviceId,
    String? roomId,
    IconData? icon,
    bool? isRead,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      deviceId: deviceId ?? this.deviceId,
      roomId: roomId ?? this.roomId,
      icon: icon ?? this.icon,
      isRead: isRead ?? this.isRead,
    );
  }

  // Format the timestamp to a readable string
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
