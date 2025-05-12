import '../../data/models/device.dart';
import '../../data/models/notification.dart';
import '../../data/models/room.dart';
import '../../data/models/sensor.dart';
import '../../data/repositories/home_repository.dart';
import 'package:flutter/material.dart'
    hide Notification; // Hide Flutter's Notification class

class DeviceService {
  final HomeRepository _repository;

  DeviceService(this._repository);

  // Room related operations
  List<Room> getAllRooms() {
    return _repository.getAllRooms();
  }

  // Device related operations
  List<Device> getAllDevices() {
    return _repository.getAllDevices();
  }

  List<Device> getDevicesByRoom(String roomId) {
    return _repository.getDevicesByRoomId(roomId);
  }

  bool isDeviceOn(String deviceId) {
    final devices = _repository.getAllDevices();
    final device = devices.firstWhere(
      (device) => device.id == deviceId,
      orElse:
          () => Device(
            id: '',
            name: '',
            roomId: '',
            type: DeviceType.other, // Changed from unknown to other
            icon: Icons.device_unknown, // Added a default icon instead of null
            isOn: false,
          ),
    );
    return device.isOn;
  }

  void toggleDevice(String deviceId, bool state) {
    _repository.toggleDeviceState(deviceId, state);
  }

  int getActiveDeviceCount() {
    final devices = _repository.getAllDevices();
    return devices.where((device) => device.isOn).length;
  }

  // Door and Garage Door operations
  List<Device> getAllDoors() {
    final devices = _repository.getAllDevices();
    return devices
        .where(
          (device) =>
              device.type == DeviceType.door ||
              device.type == DeviceType.garageDoor,
        )
        .toList();
  }

  void setDoorOpenPercentage(String deviceId, double percentage) {
    final devices = _repository.getAllDevices();
    final deviceIndex = devices.indexWhere((device) => device.id == deviceId);

    if (deviceIndex != -1) {
      final device = devices[deviceIndex];

      // Only apply to door or garage door devices
      if (device.type == DeviceType.door ||
          device.type == DeviceType.garageDoor) {
        // Clamp percentage between 0 and 100
        final clampedPercentage = percentage.clamp(0.0, 100.0);

        // Update openPercentage
        devices[deviceIndex] = device.copyWith(
          openPercentage: clampedPercentage,
          isOn: clampedPercentage > 0, // Door is considered "on" if open
        );
      }
    }
  }

  // Sensor related operations
  List<Sensor> getAllSensors() {
    return _repository.getAllSensors();
  }

  // Notification related operations
  List<Notification> getAllNotifications() {
    return _repository.getAllNotifications();
  }

  List<Notification> getUnreadNotifications() {
    return _repository.getUnreadNotifications();
  }

  int getUnreadNotificationCount() {
    return _repository.getUnreadNotificationCount();
  }

  void markNotificationAsRead(String id) {
    _repository.markNotificationAsRead(id);
  }

  void markAllNotificationsAsRead() {
    _repository.markAllNotificationsAsRead();
  }

  Future<List<Notification>> fetchNotificationsFromApi() {
    return _repository.fetchNotificationsFromApi();
  }
}
