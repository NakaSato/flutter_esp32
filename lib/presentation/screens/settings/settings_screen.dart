import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/settings_model.dart';

class SettingsScreen extends StatefulWidget {
  final String title;

  const SettingsScreen({super.key, required this.title});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Initial settings model
  SettingsModel _settings = SettingsModel();
  final TextEditingController _deviceNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _deviceNameController.text = _settings.deviceName;
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing_md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Settings Section
            _buildSectionHeader(
              'App Settings',
              Icons.tune,
              colorScheme,
              textTheme,
            ),
            _buildCard(
              context,
              Column(
                children: [
                  _buildSwitchListTile(
                    title: 'Dark Mode',
                    subtitle: 'Enable dark mode theme',
                    value: _settings.isDarkMode,
                    icon: Icons.dark_mode,
                    onChanged: (value) {
                      setState(() {
                        _settings = _settings.copyWith(isDarkMode: value);
                      });
                    },
                  ),
                  const Divider(),
                  _buildSwitchListTile(
                    title: 'Notifications',
                    subtitle: 'Enable push notifications',
                    value: _settings.notificationsEnabled,
                    icon: Icons.notifications,
                    onChanged: (value) {
                      setState(() {
                        _settings = _settings.copyWith(
                          notificationsEnabled: value,
                        );
                      });
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.thermostat, color: colorScheme.primary),
                    title: const Text('Temperature Unit'),
                    subtitle: Text(
                      _settings.temperatureUnit == 0
                          ? 'Celsius (°C)'
                          : 'Fahrenheit (°F)',
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(
                        right: AppTheme.spacing_sm,
                      ),
                      child: SegmentedButton<int>(
                        segments: const [
                          ButtonSegment<int>(value: 0, label: Text('°C')),
                          ButtonSegment<int>(value: 1, label: Text('°F')),
                        ],
                        selected: {_settings.temperatureUnit.toInt()},
                        onSelectionChanged: (values) {
                          setState(() {
                            _settings = _settings.copyWith(
                              temperatureUnit: values.first.toDouble(),
                            );
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing_lg),

            // Device Settings Section
            _buildSectionHeader(
              'Device Settings',
              Icons.devices,
              colorScheme,
              textTheme,
            ),
            _buildCard(
              context,
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.spacing_md),
                    child: TextField(
                      controller: _deviceNameController,
                      decoration: InputDecoration(
                        labelText: 'Device Name',
                        prefixIcon: Icon(
                          Icons.edit,
                          color: colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadius,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _settings = _settings.copyWith(deviceName: value);
                        });
                      },
                    ),
                  ),
                  const Divider(),
                  _buildSwitchListTile(
                    title: 'Location Services',
                    subtitle: 'Allow access to device location',
                    value: _settings.locationPermissionGranted,
                    icon: Icons.location_on,
                    onChanged: (value) {
                      setState(() {
                        _settings = _settings.copyWith(
                          locationPermissionGranted: value,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing_lg),

            // Connected Devices Section
            _buildSectionHeader(
              'Connected Devices',
              Icons.bluetooth,
              colorScheme,
              textTheme,
            ),
            _buildCard(
              context,
              _settings.connectedDevices.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(AppTheme.spacing_md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('No devices connected'),
                        const SizedBox(height: AppTheme.spacing_md),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Handle scan for devices
                            // This is a placeholder for future functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Scanning for devices...'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.search),
                          label: const Text('Scan for Devices'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _settings.connectedDevices.length,
                    itemBuilder: (context, index) {
                      final device = _settings.connectedDevices[index];
                      return ListTile(
                        leading: Icon(
                          Icons.device_hub,
                          color: colorScheme.primary,
                        ),
                        title: Text(device),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            // Remove device
                            setState(() {
                              final updatedDevices = List<String>.from(
                                _settings.connectedDevices,
                              );
                              updatedDevices.removeAt(index);
                              _settings = _settings.copyWith(
                                connectedDevices: updatedDevices,
                              );
                            });
                          },
                        ),
                      );
                    },
                  ),
            ),

            const SizedBox(height: AppTheme.spacing_lg),

            // Privacy & Security Section
            _buildSectionHeader(
              'Privacy & Security',
              Icons.security,
              colorScheme,
              textTheme,
            ),
            _buildCard(
              context,
              Column(
                children: [
                  _buildSwitchListTile(
                    title: 'Analytics',
                    subtitle: 'Share anonymous usage data',
                    value: _settings.analyticsEnabled,
                    icon: Icons.analytics,
                    onChanged: (value) {
                      setState(() {
                        _settings = _settings.copyWith(analyticsEnabled: value);
                      });
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.policy, color: colorScheme.primary),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to privacy policy
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Privacy Policy tapped'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: colorScheme.primary,
                    ),
                    title: const Text('About'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to about page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('About tapped'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing_lg),

            // Action Buttons
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Save settings
                      // This is a placeholder for future shared preferences implementation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings saved successfully!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      minimumSize: const Size(200, 50),
                    ),
                    child: const Text('Save Settings'),
                  ),
                  const SizedBox(height: AppTheme.spacing_md),
                  TextButton(
                    onPressed: () {
                      // Reset settings to default
                      setState(() {
                        _settings = SettingsModel();
                        _deviceNameController.text = _settings.deviceName;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings reset to default'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text('Reset to Default'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing_lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing_sm,
        vertical: AppTheme.spacing_md,
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 24),
          const SizedBox(width: AppTheme.spacing_sm),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Widget child) {
    return Card(
      elevation: AppTheme.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: child,
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
    );
  }
}
