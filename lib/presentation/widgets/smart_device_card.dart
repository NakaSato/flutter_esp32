import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/device.dart';
import 'neumorphic_widgets.dart';

class SmartDeviceCard extends StatelessWidget {
  final Device device;
  final bool isOn;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;
  final double value;
  final ValueChanged<double> onValueChanged;
  final String valueLabel;

  const SmartDeviceCard({
    super.key,
    required this.device,
    required this.isOn,
    required this.onToggle,
    required this.onTap,
    required this.value,
    required this.onValueChanged,
    this.valueLabel = 'Intensity',
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return NeumorphicCard(
      onTap: onTap,
      isActive: isOn,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Device icon and name
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        height: 38,
                        width: 38,
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
                                isOn
                                    ? theme.colorScheme.primary
                                    : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          device.icon,
                          color:
                              isOn
                                  ? theme.colorScheme.primary
                                  : isDarkMode
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.lightTextSecondary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
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
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isOn ? 'ON' : 'OFF',
                              style: TextStyle(
                                color:
                                    isOn
                                        ? theme.colorScheme.primary
                                        : isDarkMode
                                        ? AppTheme.darkTextSecondary
                                        : AppTheme.lightTextSecondary,
                                fontWeight:
                                    isOn ? FontWeight.bold : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Switch
                Switch(
                  value: isOn,
                  onChanged: onToggle,
                  activeColor: theme.colorScheme.primary,
                ),
              ],
            ),

            // Intensity slider
            if (isOn) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.brightness_low,
                    color:
                        isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.lightTextSecondary,
                    size: 16,
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4.0,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 8.0,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 14.0,
                        ),
                      ),
                      child: Slider(
                        value: value,
                        onChanged: onValueChanged,
                        activeColor: theme.colorScheme.primary,
                        inactiveColor:
                            isDarkMode
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.brightness_high,
                    color:
                        isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.lightTextSecondary,
                    size: 16,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '$valueLabel: ${(value * 100).toInt()}%',
                  style: TextStyle(
                    color:
                        isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.lightTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SmartDeviceDetailCard extends StatelessWidget {
  final Device device;
  final bool isOn;
  final Function(bool) onToggle;
  final double? value;
  final Function(double)? onValueChanged;
  final List<Map<String, dynamic>>? stats;
  final Widget? chart;

  const SmartDeviceDetailCard({
    super.key,
    required this.device,
    required this.isOn,
    required this.onToggle,
    this.value,
    this.onValueChanged,
    this.stats,
    this.chart,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    // Function to build stat items
    Widget buildStatItem(String label, String value, IconData icon) {
      return NeumorphicContainer(
        height: 80,
        width: MediaQuery.of(context).size.width / 2 - 24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary.withOpacity(0.8),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    isDarkMode
                        ? AppTheme.darkTextPrimary
                        : AppTheme.lightTextPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color:
                    isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with device info
        NeumorphicContainer(
          height: 100,
          isActive: isOn,
          child: Row(
            children: [
              Icon(
                device.icon,
                size: 50,
                color:
                    isOn
                        ? theme.colorScheme.primary
                        : isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      device.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color:
                            isOn
                                ? theme.colorScheme.primary
                                : isDarkMode
                                ? AppTheme.darkTextPrimary
                                : AppTheme.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Room: ${device.roomId}',
                      style: TextStyle(
                        color:
                            isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              NeumorphicSwitch(
                value: isOn,
                onChanged: onToggle,
                width: 70,
                height: 35,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Controls section
        if (value != null && onValueChanged != null) ...[
          Text(
            'Intensity',
            style: theme.textTheme.titleMedium?.copyWith(
              color:
                  isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          NeumorphicContainer(
            height: 120,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.brightness_low,
                      color:
                          isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                    ),
                    Text(
                      '${(value! * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            isOn
                                ? theme.colorScheme.primary
                                : isDarkMode
                                ? AppTheme.darkTextPrimary
                                : AppTheme.lightTextPrimary,
                      ),
                    ),
                    Icon(
                      Icons.brightness_high,
                      color:
                          isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                NeumorphicSlider(
                  value: value!,
                  min: 0.0,
                  max: 1.0,
                  onChanged: isOn ? onValueChanged : null,
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Stats section
        if (stats != null && stats!.isNotEmpty) ...[
          Text(
            'Statistics',
            style: theme.textTheme.titleMedium?.copyWith(
              color:
                  isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children:
                stats!
                    .map(
                      (stat) => buildStatItem(
                        stat['label'],
                        stat['value'],
                        stat['icon'],
                      ),
                    )
                    .toList(),
          ),
        ],

        const SizedBox(height: 24),

        // Chart section
        if (chart != null) ...[
          Text(
            'Usage History',
            style: theme.textTheme.titleMedium?.copyWith(
              color:
                  isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          NeumorphicContainer(height: 200, child: chart!),
        ],
      ],
    );
  }
}
