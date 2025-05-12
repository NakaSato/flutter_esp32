// Settings model to handle app configuration
class SettingsModel {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final double temperatureUnit; // 0 for Celsius, 1 for Fahrenheit
  final bool locationPermissionGranted;
  final String deviceName;
  final String deviceId;
  final List<String> connectedDevices;
  final bool analyticsEnabled;

  SettingsModel({
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.temperatureUnit = 0, // Default to Celsius
    this.locationPermissionGranted = false,
    this.deviceName = 'My Home Hub',
    this.deviceId = '',
    this.connectedDevices = const [],
    this.analyticsEnabled = true,
  });

  // Create a copy of the model with updated fields
  SettingsModel copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    double? temperatureUnit,
    bool? locationPermissionGranted,
    String? deviceName,
    String? deviceId,
    List<String>? connectedDevices,
    bool? analyticsEnabled,
  }) {
    return SettingsModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      locationPermissionGranted:
          locationPermissionGranted ?? this.locationPermissionGranted,
      deviceName: deviceName ?? this.deviceName,
      deviceId: deviceId ?? this.deviceId,
      connectedDevices: connectedDevices ?? this.connectedDevices,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
    );
  }
}
