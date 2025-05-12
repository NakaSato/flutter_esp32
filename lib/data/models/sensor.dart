import 'package:flutter/material.dart';

class Sensor {
  final String id;
  final String name;
  final IconData icon;
  final String value;
  final String unit;

  Sensor({
    required this.id,
    required this.name,
    required this.icon,
    required this.value,
    required this.unit,
  });

  String get displayValue => '$value$unit';
}
