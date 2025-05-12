import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'neumorphic_widgets.dart';

class Device {
  double? value; // Current device value (e.g. door position)
  DeviceType type; // Type of device
  String name; // Name of the device

  Device({this.value, required this.type, required this.name});
}

enum DeviceType { garageDoor, door }

class DoorCard extends StatelessWidget {
  final Device device;
  final Function(double) onPositionChanged;

  const DoorCard({
    super.key,
    required this.device,
    required this.onPositionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    // Get the current door position percentage (0 = closed, 1 = open)
    final doorPosition = device.value ?? 0.0;
    final isOpen = doorPosition > 0.1;

    return NeumorphicContainer(
      height: 160, // Increased height to prevent overflow
      isActive: isOpen,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use minimum space needed
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Door icon and name
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color:
                            isOpen
                                ? theme.colorScheme.primary.withOpacity(0.2)
                                : isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isOpen
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        device.type == DeviceType.garageDoor
                            ? Icons.garage
                            : Icons.door_front_door,
                        color:
                            isOpen
                                ? theme.colorScheme.primary
                                : isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
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
                        Text(
                          isOpen ? 'Open' : 'Closed',
                          style: TextStyle(
                            color:
                                isOpen
                                    ? theme.colorScheme.primary
                                    : isDarkMode
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.lightTextSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Current position indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${(doorPosition * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            isOpen
                                ? theme.colorScheme.primary
                                : isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isOpen ? 'Open' : 'Closed',
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
              ],
            ),

            const SizedBox(height: 16), // Reduced space from 20px to 16px
            // Slider for door position
            Row(
              children: [
                Icon(
                  Icons.door_sliding_outlined,
                  color:
                      isDarkMode
                          ? AppTheme.darkTextSecondary.withOpacity(0.7)
                          : AppTheme.lightTextSecondary.withOpacity(0.7),
                  size: 18, // Reduced size from 20px to 18px
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 6,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                      activeTrackColor: theme.colorScheme.primary,
                      inactiveTrackColor:
                          isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                      thumbColor: theme.colorScheme.primary,
                    ),
                    child: Slider(
                      value: doorPosition,
                      onChanged: onPositionChanged,
                      min: 0.0,
                      max: 1.0,
                    ),
                  ),
                ),
                Icon(
                  Icons.door_back_door_outlined,
                  color:
                      isDarkMode
                          ? AppTheme.darkTextSecondary.withOpacity(0.7)
                          : AppTheme.lightTextSecondary.withOpacity(0.7),
                  size: 18, // Reduced size from 20px to 18px
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
