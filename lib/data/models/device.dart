import 'package:flutter/material.dart';

enum DeviceType { light, door, garageDoor, other }

class Device {
  final String id;
  final String name;
  final IconData icon;
  final String roomId;
  final DeviceType type;
  bool isOn;
  double?
  openPercentage; // For doors and garage doors that can be partially open

  Device({
    required this.id,
    required this.name,
    required this.icon,
    required this.roomId,
    this.type = DeviceType.other,
    this.isOn = false,
    this.openPercentage,
  });

  Device copyWith({
    String? id,
    String? name,
    IconData? icon,
    String? roomId,
    DeviceType? type,
    bool? isOn,
    double? openPercentage,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      roomId: roomId ?? this.roomId,
      type: type ?? this.type,
      isOn: isOn ?? this.isOn,
      openPercentage: openPercentage ?? this.openPercentage,
    );
  }
}
