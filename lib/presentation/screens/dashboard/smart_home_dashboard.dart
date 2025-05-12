import 'package:flutter/material.dart';
import '../../../data/models/device.dart';
import '../../../data/models/room.dart';
import '../../../data/models/sensor.dart';
import '../../../data/repositories/home_repository.dart';
import '../../../data/services/device_service.dart'; // Add new import
import '../../widgets/door_card.dart' as door_widget;
import '../../widgets/room_card.dart';
import '../../widgets/sensor_card.dart';
import '../../widgets/status_card.dart';
import '../../widgets/smart_device_card.dart';
import '../../widgets/neumorphic_widgets.dart';
import '../../../core/theme/app_theme.dart';
import '../notifications/notifications_screen.dart';
import '../analytics/analytics_screen.dart';
import '../settings/settings_screen.dart';

class SmartHomeDashboard extends StatefulWidget {
  const SmartHomeDashboard({super.key, required this.title});
  final String title;

  @override
  State<SmartHomeDashboard> createState() => _SmartHomeDashboardState();
}

class _SmartHomeDashboardState extends State<SmartHomeDashboard> {
  late final HomeRepository _repository;
  late final DeviceService _deviceService;
  int _currentIndex = 0;

  // Device states mapped by room IDs
  final Map<String, bool> _deviceStates = {};

  // Device intensity values
  final Map<String, double> _deviceValues = {};

  // Sensor data
  late List<Sensor> _sensors;

  @override
  void initState() {
    super.initState();

    // Initialize repository and service
    _repository = HomeRepository();
    _deviceService = DeviceService(_repository);

    // Initialize device states
    for (final room in _deviceService.getAllRooms()) {
      _deviceStates[room.id] = false;
    }

    // Initialize device intensity values
    for (final device in _deviceService.getAllDevices()) {
      _deviceValues[device.id] = 0.7; // Default value
    }

    // Get sensors
    _sensors = _deviceService.getAllSensors();
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return AnalyticsScreen();
      case 2:
        return _buildDevicesScreen();
      case 3:
        return SettingsScreen(title: 'Settings');
      default:
        return _buildHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90), // Further reduced from 100 to 90
        child: Container(
          decoration: BoxDecoration(
            color:
                isDarkMode ? AppTheme.darkCardColor : AppTheme.lightCardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // User avatar
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.3,
                                ),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.person_outline_rounded,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(width: 12),
                          // Title and welcome text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color:
                                      isDarkMode
                                          ? AppTheme.darkTextSecondary
                                          : AppTheme.lightTextSecondary,
                                ),
                              ),
                              Text(
                                widget.title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode
                                          ? AppTheme.darkTextPrimary
                                          : AppTheme.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Enhanced notifications button
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              NeumorphicIconButton(
                                icon: Icons.notifications_outlined,
                                size: 42,
                                isActive:
                                    _deviceService
                                        .getUnreadNotificationCount() >
                                    0,
                                onPressed: () {
                                  // Navigate to notifications screen
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => NotificationsScreen(
                                                deviceService: _deviceService,
                                              ),
                                        ),
                                      )
                                      .then((_) {
                                        // Force rebuild to update notification badge when returning from notification screen
                                        setState(() {});
                                      });
                                },
                              ),
                              if (_deviceService.getUnreadNotificationCount() >
                                  0)
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            isDarkMode
                                                ? AppTheme.darkCardColor
                                                : Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${_deviceService.getUnreadNotificationCount()}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Current status row
                  _buildStatusRow(isDarkMode, theme),
                ],
              ),
            ),
          ),
        ),
      ),
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
          top:
              false, // Since we're handling the top padding with the custom app bar
          child: _buildCurrentScreen(),
        ),
      ),
      floatingActionButton:
          _currentIndex == 0 || _currentIndex == 2
              ? FloatingActionButton(
                onPressed: _showAddDeviceDialog,
                tooltip: 'Add Device',
                backgroundColor: theme.colorScheme.primary,
                elevation: 4,
                child: const Icon(Icons.add),
              )
              : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.darkCardColor : AppTheme.lightCardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0), // Reduced vertical padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavBarItem(0, Icons.home_outlined, 'Home'),
              _buildNavBarItem(1, Icons.insert_chart_outlined, 'Analytics'),
              _buildNavBarItem(2, Icons.devices_outlined, 'Devices'),
              _buildNavBarItem(3, Icons.settings_outlined, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(int index, IconData icon, String label) {
    final isSelected = index == _currentIndex;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _onBottomNavTapped(index),
      child: AnimatedContainer(
        duration: AppTheme.shortAnimationDuration,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6), // Reduced vertical padding
        decoration:
            isSelected
                ? BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                )
                : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? theme.colorScheme.primary
                      : isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary,
              size: 22, // Reduced size
            ),
            const SizedBox(height: 2), // Reduced spacing
            Text(
              label,
              style: TextStyle(
                fontSize: 11, // Reduced font size
                color:
                    isSelected
                        ? theme.colorScheme.primary
                        : isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Status overview
          StatusCard(
            activeDevices: _deviceService.getActiveDeviceCount(),
            temperature: '${_sensors[0].value}${_sensors[0].unit}',
            humidity: '${_sensors[1].value}${_sensors[1].unit}',
          ),
          const SizedBox(height: 16),

          // Room controls
          _sectionHeader(context, 'Rooms', Icons.meeting_room),
          const SizedBox(height: 12),
          _buildRoomControls(),
          const SizedBox(height: 16),

          // Smart devices
          _sectionHeader(context, 'Smart Devices', Icons.devices),
          const SizedBox(height: 12),
          _buildSmartDeviceGrid(),
          const SizedBox(height: 16),

          // Doors and Garage Doors
          _sectionHeader(context, 'Doors & Garage', Icons.door_front_door),
          const SizedBox(height: 12),
          _buildDoorControls(),
          const SizedBox(height: 16),

          // Sensors
          _sectionHeader(context, 'Sensors', Icons.sensors),
          const SizedBox(height: 12),
          _buildSensors(),
          // Add padding at the bottom for better scrolling experience
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDevicesScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Devices',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Group devices by room
          ..._buildDevicesByRoom(),
        ],
      ),
    );
  }

  List<Widget> _buildDevicesByRoom() {
    final List<Widget> widgets = [];
    final rooms = _deviceService.getAllRooms();

    for (Room room in rooms) {
      final devices = _deviceService.getDevicesByRoom(room.id);

      if (devices.isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: _sectionHeader(context, room.name, room.icon),
          ),
        );

        widgets.add(
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: devices.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final device = devices[index];
              final isOn = _deviceService.isDeviceOn(device.id);

              return NeumorphicCard(
                onTap: () => _navigateToDeviceDetail(device),
                isActive: isOn,
                height: 80,
                child: Row(
                  children: [
                    Icon(
                      device.icon,
                      color:
                          isOn
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).brightness == Brightness.dark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            device.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  isOn
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                            ),
                          ),
                          Text('Room: ${room.name}'),
                        ],
                      ),
                    ),
                    NeumorphicSwitch(
                      value: isOn,
                      onChanged: (value) {
                        setState(() {
                          _deviceService.toggleDevice(device.id, value);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    }

    return widgets;
  }

  void _navigateToDeviceDetail(Device device) {
    final isOn = _deviceService.isDeviceOn(device.id);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: Text(device.name), elevation: 0),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors:
                        Theme.of(context).brightness == Brightness.dark
                            ? [AppTheme.darkBackground, Color(0xFF1A1A1A)]
                            : [AppTheme.lightBackground, Color(0xFFEAEAEA)],
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: SmartDeviceDetailCard(
                      device: device,
                      isOn: isOn,
                      onToggle: (value) {
                        setState(() {
                          _deviceService.toggleDevice(device.id, value);
                        });
                      },
                      value: _deviceValues[device.id] ?? 0.0,
                      onValueChanged: (value) {
                        setState(() {
                          _deviceValues[device.id] = value;
                        });
                      },
                      stats: [
                        {'label': 'Power', 'value': '85W', 'icon': Icons.power},
                        {
                          'label': 'Today',
                          'value': '3.2 kWh',
                          'icon': Icons.today,
                        },
                        {
                          'label': 'Uptime',
                          'value': '5h 23m',
                          'icon': Icons.timer,
                        },
                        {
                          'label': 'Signal',
                          'value': 'Strong',
                          'icon': Icons.signal_cellular_alt,
                        },
                      ],
                      chart: CustomPaint(
                        size: Size(double.infinity, 150),
                        painter: _ChartPainter(
                          color: Theme.of(context).colorScheme.primary,
                          isDarkMode:
                              Theme.of(context).brightness == Brightness.dark,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showAddDeviceDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            backgroundColor:
                isDarkMode ? AppTheme.darkCardColor : AppTheme.lightCardColor,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.add_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Add Device',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Choose the type of device to add:'),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildDeviceTypeOption(
                        context,
                        Icons.lightbulb_outline,
                        'Light',
                      ),
                      _buildDeviceTypeOption(
                        context,
                        Icons.thermostat,
                        'Thermostat',
                      ),
                      _buildDeviceTypeOption(context, Icons.tv, 'TV'),
                      _buildDeviceTypeOption(context, Icons.speaker, 'Speaker'),
                      _buildDeviceTypeOption(context, Icons.outlet, 'Plug'),
                      _buildDeviceTypeOption(
                        context,
                        Icons.videocam_outlined,
                        'Camera',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildDeviceTypeOption(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label setup will be available soon')),
        );
      },
      child: Container(
        width: 80,
        height: 90,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomControls() {
    final rooms = _deviceService.getAllRooms();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rooms.length + 1, // +1 for the "Add Room" card
      itemBuilder: (context, index) {
        if (index == rooms.length) {
          return _buildAddRoomCard();
        }

        final room = rooms[index];
        return RoomCard(
          room: room,
          isOn: _deviceStates[room.id] ?? false,
          onChanged: (value) {
            setState(() {
              _deviceStates[room.id] = value;
              final devices = _deviceService.getDevicesByRoom(room.id);
              for (final device in devices) {
                _deviceService.toggleDevice(device.id, value);
              }
            });
          },
        );
      },
    );
  }

  Widget _buildSmartDeviceGrid() {
    // Get some example devices - you would normally get these from a service
    final List<Device> devices =
        _deviceService.getAllDevices().take(4).toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.64,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        final isOn = _deviceService.isDeviceOn(device.id);

        return SmartDeviceCard(
          device: device,
          isOn: isOn,
          onToggle: (value) {
            setState(() {
              _deviceService.toggleDevice(device.id, value);
            });
          },
          onTap: () => _navigateToDeviceDetail(device),
          value: _deviceValues[device.id] ?? 0.0,
          onValueChanged: (value) {
            setState(() {
              _deviceValues[device.id] = value;
            });
          },
          valueLabel:
              device.type == DeviceType.light ? 'Brightness' : 'Intensity',
        );
      },
    );
  }

  Widget _buildAddRoomCard() {
    return NeumorphicCard(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add room will be available soon')),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle,
            size: 40,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 8),
          const Text(
            'Add Room',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDoorControls() {
    final doors = _deviceService.getAllDoors();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: doors.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final door = doors[index];
        return door_widget.DoorCard(
          device: door_widget.Device(
            name: door.name,
            type: door_widget.DeviceType.values.firstWhere(
              (type) =>
                  type.toString() ==
                  'DeviceType.${door.type.toString().split('.').last}',
              orElse: () => door_widget.DeviceType.door,
            ),
            value: _deviceService.getDoorOpenPercentage(door.id),
          ),
          onPositionChanged: (percentage) {
            setState(() {
              _deviceService.setDoorOpenPercentage(door.id, percentage);
            });
          },
        );
      },
    );
  }

  Widget _buildSensors() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sensors.length,
      itemBuilder: (context, index) {
        return SensorCard(sensor: _sensors[index]);
      },
    );
  }

  Widget _buildStatusRow(bool isDarkMode, ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatusCard(
            icon: Icons.devices,
            label: 'Active Devices',
            value: '${_deviceService.getActiveDeviceCount()}',
            isDarkMode: isDarkMode,
            theme: theme,
          ),
          const SizedBox(width: 8),
          _buildStatusCard(
            icon: Icons.thermostat,
            label: 'Temperature',
            value: '${_sensors[0].value}${_sensors[0].unit}',
            isDarkMode: isDarkMode,
            theme: theme,
          ),
          const SizedBox(width: 8),
          _buildStatusCard(
            icon: Icons.water_drop,
            label: 'Humidity',
            value: '${_sensors[1].value}${_sensors[1].unit}',
            isDarkMode: isDarkMode,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String label,
    required String value,
    required bool isDarkMode,
    required ThemeData theme,
  }) {
    return Container(
      width: 110,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10), // Reduced vertical padding
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
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this to ensure minimal height
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 22), // Reduced size from 24 to 22
          SizedBox(height: 4), // Reduced from 6 to 4
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2), // Reduced from 4 to 2
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color:
                  isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final Color color;
  final bool isDarkMode;

  _ChartPainter({required this.color, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint =
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final Paint areaFillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Paint gridPaint =
        Paint()
          ..color = (isDarkMode ? Colors.white : Colors.black).withOpacity(0.1)
          ..strokeWidth = 1;

    // Draw horizontal grid lines
    for (int i = 0; i <= 3; i++) {
      final double y = size.height / 3 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Create random power usage curve
    final Path path = Path();
    final Path areaPath = Path();

    path.moveTo(0, size.height * 0.7);
    areaPath.moveTo(0, size.height);
    areaPath.lineTo(0, size.height * 0.7);

    // Morning rise
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.65,
      size.width * 0.3,
      size.height * 0.3,
      size.width * 0.35,
      size.height * 0.4,
    );

    // Midday peak
    path.cubicTo(
      size.width * 0.4,
      size.height * 0.5,
      size.width * 0.5,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.3,
    );

    // Evening peak
    path.cubicTo(
      size.width * 0.7,
      size.height * 0.4,
      size.width * 0.8,
      size.height * 0.2,
      size.width * 0.9,
      size.height * 0.5,
    );

    // Night drop-off
    path.cubicTo(
      size.width * 0.95,
      size.height * 0.6,
      size.width,
      size.height * 0.7,
      size.width,
      size.height * 0.6,
    );

    // Complete the area path
    areaPath.addPath(path, Offset.zero);
    areaPath.lineTo(size.width, size.height);
    areaPath.close();

    // Draw the filled area first
    canvas.drawPath(areaPath, areaFillPaint);

    // Then draw the line on top
    canvas.drawPath(path, linePaint);

    // Draw time labels
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final List<String> timeLabels = [
      '00:00',
      '06:00',
      '12:00',
      '18:00',
      '24:00',
    ];

    for (int i = 0; i < timeLabels.length; i++) {
      final double x = size.width / (timeLabels.length - 1) * i;

      textPainter.text = TextSpan(
        text: timeLabels[i],
        style: TextStyle(
          color: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.6),
          fontSize: 10,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - textPainter.height),
      );

      // Draw tick mark
      canvas.drawLine(
        Offset(x, size.height - 15),
        Offset(x, size.height - 10),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
