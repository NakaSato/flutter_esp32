import '../../data/models/device.dart';
import '../../data/models/room.dart';
import '../../data/models/sensor.dart';
import '../../data/repositories/home_repository.dart';

class DeviceService {
  final HomeRepository _repository;
  // Map to store door open percentages
  final Map<String, double> _doorOpenPercentages = {};
  // Map to store device on/off states
  final Map<String, bool> _deviceStates = {};
  // Map to store unread notification count
  int _unreadNotificationCount = 2; // Default value for demo

  DeviceService(this._repository) {
    _initializeDeviceStates();
  }

  // Initialize device states
  void _initializeDeviceStates() {
    // Initialize door positions
    for (final door in getAllDoors()) {
      _doorOpenPercentages[door.id] = 0.0; // Closed by default
    }

    // Initialize device states
    for (final device in getAllDevices()) {
      _deviceStates[device.id] = false; // Off by default
    }
  }

  // Get all rooms
  List<Room> getAllRooms() {
    return _repository.getAllRooms();
  }

  // Get all devices
  List<Device> getAllDevices() {
    return _repository.getAllDevices();
  }

  // Get all doors
  List<Device> getAllDoors() {
    return _repository
        .getAllDevices()
        .where(
          (device) =>
              device.type == DeviceType.door ||
              device.type == DeviceType.garageDoor,
        )
        .toList();
  }

  // Get all sensors
  List<Sensor> getAllSensors() {
    return _repository.getAllSensors();
  }

  // Get devices by room
  List<Device> getDevicesByRoom(String roomId) {
    return _repository
        .getAllDevices()
        .where((device) => device.roomId == roomId)
        .toList();
  }

  // Toggle device state
  void toggleDevice(String deviceId, bool isOn) {
    _deviceStates[deviceId] = isOn;
  }

  // Check if device is on
  bool isDeviceOn(String deviceId) {
    return _deviceStates[deviceId] ?? false;
  }

  // Get door open percentage
  double getDoorOpenPercentage(String doorId) {
    return _doorOpenPercentages[doorId] ?? 0.0;
  }

  // Set door open percentage
  void setDoorOpenPercentage(String doorId, double percentage) {
    _doorOpenPercentages[doorId] = percentage;
  }

  // Get active device count
  int getActiveDeviceCount() {
    return _deviceStates.values.where((isOn) => isOn).length;
  }

  // Get unread notification count
  int getUnreadNotificationCount() {
    return _unreadNotificationCount;
  }

  // Mark notifications as read
  void markNotificationsAsRead() {
    _unreadNotificationCount = 0;
  }
}
