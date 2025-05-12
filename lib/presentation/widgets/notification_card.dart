import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/notification.dart' as app_notification;

class NotificationCard extends StatelessWidget {
  final app_notification.Notification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  final VoidCallback onMarkAsRead;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
    required this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    // Swipeable card with actions
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        decoration: BoxDecoration(
          color:
              notification.isRead
                  ? colorScheme.surfaceContainerHighest
                  : colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        child: Icon(
          Icons.check_circle_outline,
          color:
              notification.isRead
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.onSecondaryContainer,
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        child: Icon(Icons.delete_outline, color: colorScheme.onError),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete action - confirm with user
          final result = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Delete Notification'),
                content: const Text(
                  'Are you sure you want to delete this notification?',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
          );
          return result ?? false;
        } else if (direction == DismissDirection.startToEnd) {
          // Mark as read action
          onMarkAsRead();
          return false; // Don't dismiss, just mark as read
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDismiss();
        }
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color:
                notification.isRead
                    ? isDarkMode
                        ? AppTheme.darkCardColor
                        : AppTheme.lightCardColor
                    : isDarkMode
                    ? colorScheme.primaryContainer.withOpacity(0.3)
                    : colorScheme.primaryContainer.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(
              color:
                  notification.isRead
                      ? Colors.transparent
                      : colorScheme.primary.withOpacity(0.3),
              width: 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification icon
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: notification.getColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  notification.icon,
                  color: notification.getColor(),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                isDarkMode
                                    ? AppTheme.darkTextPrimary
                                    : AppTheme.lightTextPrimary,
                          ),
                        ),
                        Text(
                          notification.formattedTime,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isDarkMode
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
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
