import 'package:flutter/material.dart';

class Room {
  final String id;
  final String name;
  final IconData icon;

  Room({required this.id, required this.name, required this.icon});

  static List<Room> predefinedRooms = [
    Room(id: 'living_room', name: 'Living Room', icon: Icons.weekend),
    Room(id: 'garage', name: 'Garage', icon: Icons.garage),
  ];
}
