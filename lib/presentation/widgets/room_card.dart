import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/room.dart';
import 'neumorphic_widgets.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final bool isOn;
  final ValueChanged<bool> onChanged;

  const RoomCard({
    super.key,
    required this.room,
    required this.isOn,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return NeumorphicCard(
      isActive: isOn,
      onTap: () => onChanged(!isOn),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Room icon with background
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color:
                        isOn
                            ? theme.colorScheme.primary.withOpacity(0.2)
                            : isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          isOn ? theme.colorScheme.primary : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    room.icon,
                    color:
                        isOn
                            ? theme.colorScheme.primary
                            : isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.lightTextSecondary,
                    size: 22,
                  ),
                ),

                // Room power status
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isOn,
                    onChanged: onChanged,
                    activeColor: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Room name
            Text(
              room.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    isDarkMode
                        ? AppTheme.darkTextPrimary
                        : AppTheme.lightTextPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Status text
            Text(
              isOn ? 'ON' : 'OFF',
              style: TextStyle(
                color:
                    isOn
                        ? theme.colorScheme.primary
                        : isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                fontWeight: isOn ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
