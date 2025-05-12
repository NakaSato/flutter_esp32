import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/device_service.dart';

class NotificationsScreen extends StatefulWidget {
  final DeviceService deviceService;

  const NotificationsScreen({super.key, required this.deviceService});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Mark notifications as read when screen is opened
    widget.deviceService.markNotificationsAsRead();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('Notifications'), elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDarkMode
                    ? [AppTheme.darkBackground, Color(0xFF1A1A1A)]
                    : [AppTheme.lightBackground, Color(0xFFEAEAEA)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildNotificationItem(
                context,
                title: 'Motion Detected',
                message: 'Front door camera detected motion',
                time: '10 minutes ago',
                icon: Icons.videocam_outlined,
                isUnread: true,
              ),
              _buildNotificationItem(
                context,
                title: 'Temperature Alert',
                message: 'Living room temperature is above threshold (28°C)',
                time: '1 hour ago',
                icon: Icons.thermostat_outlined,
                isUnread: true,
              ),
              _buildNotificationItem(
                context,
                title: 'Device Update Available',
                message: 'Smart TV firmware update is available',
                time: 'Yesterday, 10:45 PM',
                icon: Icons.system_update_outlined,
                isUnread: false,
              ),
              _buildNotificationItem(
                context,
                title: 'Door Left Open',
                message: 'Garage door has been open for more than 30 minutes',
                time: 'Yesterday, 6:20 PM',
                icon: Icons.door_front_door_outlined,
                isUnread: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required bool isUnread,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.darkCardColor : AppTheme.lightCardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight:
                                  isUnread
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        color:
                            isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isDarkMode
                                ? AppTheme.darkTextSecondary.withOpacity(0.7)
                                : AppTheme.lightTextSecondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
