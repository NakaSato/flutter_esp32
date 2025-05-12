import 'package:flutter/material.dart';
import '../../../data/models/device.dart';

class DeviceDetailsScreen extends StatefulWidget {
  final Device device;
  final Function(bool) onToggle;

  const DeviceDetailsScreen({
    super.key,
    required this.device,
    required this.onToggle,
  });

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.device.isOn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device icon and status
            Center(
              child: Column(
                children: [
                  Icon(
                    widget.device.icon,
                    size: 100,
                    color:
                        _isOn
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _isOn ? 'ON' : 'OFF',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:
                          _isOn
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Switch(
                    value: _isOn,
                    onChanged: (value) {
                      setState(() {
                        _isOn = value;
                        widget.onToggle(value);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Device details
            const Text(
              'Device Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Device ID', widget.device.id),
            _buildInfoRow('Room', widget.device.roomId),

            // Additional controls would go here
            const Spacer(),

            // Settings button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Show device settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Device settings coming soon'),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
                label: const Text('Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
