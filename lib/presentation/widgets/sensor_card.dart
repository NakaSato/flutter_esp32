import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/sensor.dart';
import 'neumorphic_widgets.dart';

class SensorCard extends StatelessWidget {
  final Sensor sensor;

  const SensorCard({super.key, required this.sensor});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    // Determine color based on sensor type and value
    Color valueColor = theme.colorScheme.primary;

    if (sensor.name.toLowerCase().contains('temperature')) {
      // Red for high temperature, blue for low
      double temp = double.tryParse(sensor.value) ?? 22.5;
      if (temp > 25) {
        valueColor = Colors.orange;
      } else if (temp < 18) {
        valueColor = Colors.lightBlue;
      } else {
        valueColor = theme.colorScheme.primary;
      }
    } else if (sensor.name.toLowerCase().contains('humidity')) {
      // Blue for high humidity, amber for low
      double humid = double.tryParse(sensor.value) ?? 45;
      if (humid > 60) {
        valueColor = Colors.lightBlue;
      } else if (humid < 30) {
        valueColor = Colors.amber;
      } else {
        valueColor = theme.colorScheme.primary;
      }
    }

    return NeumorphicContainer(
      child: Container(
        constraints: const BoxConstraints(minHeight: 110.7), // Set minimum height to match constraint
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sensor type icon
                  Container(
                    height: 32, // Further reduced size
                    width: 32,  // Further reduced size
                    decoration: BoxDecoration(
                      color: valueColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(sensor.icon, color: valueColor, size: 20),
                  ),
                  
                  // Sensor status indicator
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8), // Further reduced spacing
              
              // Sensor name
              Text(
                sensor.name,
                style: theme.textTheme.bodyMedium?.copyWith( // Smaller text size
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4), // Further reduced spacing
              
              // Sensor value
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      sensor.value,
                      style: TextStyle(
                        fontSize: 20, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: valueColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 2), // Reduced spacing
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0), // Reduced padding
                    child: Text(
                      sensor.unit,
                      style: TextStyle(
                        fontSize: 12, // Reduced font size
                        color: isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
