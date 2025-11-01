import 'package:flutter/material.dart';

// Client Constants
class ClientStatus {
  static const String active = 'active';
  static const String inactive = 'inactive';
  static const String suspended = 'suspended';
  static const String trial = 'trial';
  static const String churned = 'churned';
}

final clientStatus = [
  ClientStatus.active,
  ClientStatus.inactive,
  ClientStatus.suspended,
  ClientStatus.trial,
  ClientStatus.churned,
];

// Hotel Constants
class HotelTypes {
  static const String hotel = 'Hotel';
  static const String resort = 'Resort';
  static const String motel = 'Motel';
  static const String villa = 'Villa';
}

final hotelTypes = [
  HotelTypes.hotel,
  HotelTypes.resort,
  HotelTypes.motel,
  HotelTypes.villa,
];

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

class UserRoles {
  static const String rm = 'rm';
  static const String gm = 'gm';
  static const String dm = 'dm';
  static const String operators = 'operators';
}

final List<Map<String, String>> roles = [
  {'key': UserRoles.rm, 'name': RoleTab.regionalManager},
  {'key': UserRoles.gm, 'name': RoleTab.generalManager},
  {'key': UserRoles.dm, 'name': RoleTab.departmentManager},
  {'key': UserRoles.operators, 'name': RoleTab.operators},
];

List<String> userRole = roles.map((role) => role['key']!).toList();

class RoleTab {
  static const String regionalManager = 'Regional Manager';
  static const String generalManager = 'General Manager';
  static const String departmentManager = 'Department Manager';
  static const String operators = 'Operators';
}

// Client Hotel Task Constants

class TaskStatus {
  static const String created = 'created';
  static const String imported = 'imported';
}

class ActiveStatus {
  static const String active = 'active';
  static const String inactive = 'inactive';
}
