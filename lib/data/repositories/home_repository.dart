import 'package:esp32/data/models/notification.dart';
import 'package:flutter/material.dart';
import '../models/device.dart';
import '../models/notification.dart' as app_notification;
import '../models/room.dart';
import '../models/sensor.dart';

class HomeRepository {
  // Simulate a database or API
  final List<Room> _rooms = Room.predefinedRooms;
  final List<Device> _devices = [
    Device(
      id: '1',
      name: 'Light',
      icon: Icons.lightbulb,
      roomId: 'living_room',
      type: DeviceType.light,
    ),
    Device(
      id: '2',
      name: 'Light',
      icon: Icons.lightbulb,
      roomId: 'bedroom',
      type: DeviceType.light,
    ),
    Device(
      id: '3',
      name: 'Light',
      icon: Icons.lightbulb,
      roomId: 'kitchen',
      type: DeviceType.light,
    ),
    Device(
      id: '4',
      name: 'Front Door',
      icon: Icons.door_front_door,
      roomId: 'entrance',
      type: DeviceType.door,
      openPercentage: 0.0,
    ),
    Device(
      id: '5',
      name: 'Back Door',
      icon: Icons.door_back_door,
      roomId: 'kitchen',
      type: DeviceType.door,
      openPercentage: 0.0,
    ),
    Device(
      id: '6',
      name: 'Garage Door',
      icon: Icons.garage,
      roomId: 'garage',
      type: DeviceType.garageDoor,
      openPercentage: 0.0,
    ),
  ];
  final List<Sensor> _sensors = [
    Sensor(
      id: '1',
      name: 'Temperature',
      icon: Icons.thermostat,
      value: '22.5',
      unit: '°C',
    ),
    Sensor(
      id: '2',
      name: 'Humidity',
      icon: Icons.water_drop,
      value: '45',
      unit: '%',
    ),
    Sensor(
      id: '3',
      name: 'Air Quality',
      icon: Icons.air,
      value: 'Good',
      unit: '',
    ),
  ];

  // List of notifications
  final List<app_notification.Notification> _notifications = [
    app_notification.Notification(
      id: '1',
      title: 'Door Left Open',
      message: 'Front door has been open for more than 10 minutes',
      type: NotificationType.alert,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      deviceId: '4',
      roomId: 'entrance',
      icon: Icons.door_front_door_outlined,
    ),
    app_notification.Notification(
      id: '2',
      title: 'High Temperature',
      message: 'Living room temperature is above normal (28°C)',
      type: NotificationType.warning,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      roomId: 'living_room',
      icon: Icons.thermostat_outlined,
    ),
    app_notification.Notification(
      id: '3',
      title: 'Motion Detected',
      message: 'Motion detected in the garage while you are away',
      type: NotificationType.info,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      roomId: 'garage',
      icon: Icons.directions_run,
    ),
    app_notification.Notification(
      id: '4',
      title: 'New Device Connected',
      message: 'Smart TV successfully connected to your network',
      type: NotificationType.success,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      roomId: 'living_room',
      icon: Icons.devices_other,
    ),
    app_notification.Notification(
      id: '5',
      title: 'Battery Low',
      message: 'Kitchen smoke detector battery is low',
      type: NotificationType.warning,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      roomId: 'kitchen',
      icon: Icons.battery_alert,
    ),
  ];

  // Room operations
  List<Room> getAllRooms() => _rooms;

  Room? getRoomById(String id) => _rooms.firstWhere(
    (room) => room.id == id,
    orElse: () => throw Exception('Room not found'),
  );

  void addRoom(Room room) {
    _rooms.add(room);
  }

  // Device operations
  List<Device> getAllDevices() => _devices;

  List<Device> getDevicesByRoomId(String roomId) =>
      _devices.where((device) => device.roomId == roomId).toList();

  void toggleDeviceState(String deviceId, bool state) {
    final deviceIndex = _devices.indexWhere((device) => device.id == deviceId);
    if (deviceIndex != -1) {
      _devices[deviceIndex].isOn = state;
    }
  }

  void addDevice(Device device) {
    _devices.add(device);
  }

  // Sensor operations
  List<Sensor> getAllSensors() => _sensors;

  // Notification operations
  List<app_notification.Notification> getAllNotifications() => _notifications;

  List<app_notification.Notification> getUnreadNotifications() =>
      _notifications.where((notification) => !notification.isRead).toList();

  int getUnreadNotificationCount() => getUnreadNotifications().length;

  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere(
      (notification) => notification.id == id,
    );
    if (index != -1) {
      _notifications[index].isRead = true;
    }
  }

  void markAllNotificationsAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
  }

  void addNotification(app_notification.Notification notification) {
    _notifications.add(notification);
  }

  // Method to simulate retrieving notifications from an API
  Future<List<app_notification.Notification>>
  fetchNotificationsFromApi() async {
    // In a real implementation, this would make an HTTP request
    // For now, just return the example data after a delay to simulate network request
    await Future.delayed(const Duration(seconds: 1));
    return _notifications;
  }
}
