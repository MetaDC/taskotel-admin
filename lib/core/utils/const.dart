import 'dart:ui';

import 'package:flutter/material.dart';

class ClientStatus {
  static const String active = 'active';
  static const String inactive = 'inactive';
  static const String suspended = 'suspended';
  static const String trial = 'trial';
  static const String churned = 'churned';
}

final hotelTypes = ["Hotel", "Resort", "Motel", "Villa"];

final List<String> departments = [
  'Housekeeping',
  'Front Office',
  'Food & Beverage',
  'Maintenance',
  'Security',
  'Management',
  'Guest Services',
  'HR',
  'Finance',
  'Kitchen',
  'Laundry',
  'Spa & Wellness',
];

final List<String> frequencies = [
  'Daily',
  'Weekly',
  'Quarterly',
  'Monthly',
  'Yearly',
];

/// Map each hotel type to a color
const hotelTypeColors = <String, Color>{
  "Hotel": Color(0xFF1B75D0), // Blue
  "Resort": Color.fromARGB(255, 255, 215, 95), // Yellow
  "Motel": Color(0xFF4CAF50), // Green
  "Villa": Color(0xFFFF9800), // Orange
};

final List<Map<String, String>> roles = [
  {'key': 'rm', 'name': 'Regional Manager'},
  {'key': 'gm', 'name': 'General Manager'},
  {'key': 'dm', 'name': 'Department Manager'},
  {'key': 'staff', 'name': 'Operators'},
];
