import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/entity/hoteltask_model.dart';
import 'package:taskoteladmin/features/clients/presentation/cubit/client_detail_cubit.dart';

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

class UserRoles {
  static const String rm = 'rm';
  static const String gm = 'gm';
  static const String dm = 'dm';
  static const String operators = 'operators';
}

final List<Map<String, String>> roles = [
  {'key': UserRoles.rm, 'name': 'Regional Manager'},
  {'key': UserRoles.gm, 'name': 'General Manager'},
  {'key': UserRoles.dm, 'name': 'Department Manager'},
  {'key': UserRoles.operators, 'name': 'Operators'},
];

List<String> userRole = roles.map((role) => role['key']!).toList();

enum RoleTab { regionalManager, generalManager, departmentManager, operators }

// Client Hotel Task Constants

class TaskStatus {
  static const String created = 'created';
  static const String imported = 'imported';
}

class ActiveStatus {
  static const String active = 'active';
  static const String inactive = 'inactive';
}

/// dummmy things
List<Map<String, dynamic>> dummyHotels = [
  {
    "name": "Grand Palace Hotel",
    "clientId": "0LXihqjvKcBcRnDcsIvG",
    "floors": {"1": 12, "2": 10, "3": 8},
    "createdAt": 1737900000000,
    "updatedAt": 1738000000000,
    "masterHotelId": "mh_001",
    "propertyType": "Luxury",
    "isActive": true,
    "subscriptionPurchaseId": "sub_001",
    "subscriptionName": "Gold Plan",
    "subscriptionStart": 1737900000000,
    "subscriptionEnd": 1769436000000,
    "logoUrl": "https://picsum.photos/100/100?random=1",
    "lastSync": 1738000000000,
    "hotelImageUrl": "https://picsum.photos/200/100?random=1",
    "addressModel": {
      "addressLine1": "123 Palace Street",
      "addressLine2": "Near Central Park",
      "city": "Mumbai",
      "state": "Maharashtra",
      "country": "India",
      "postalCode": "400001",
    },
    "otherDocuments": {"license": "https://example.com/license1.pdf"},
    "totalUser": 25,
    "totaltask": 80,
    "totalRevenue": 1500000,
  },
  {
    "name": "Sea Breeze Resort",
    "clientId": "0kVDACjkAiS2knlaPLUY",
    "floors": {"1": 15, "2": 15, "3": 12},
    "createdAt": 1737901000000,
    "updatedAt": 1738001000000,
    "masterHotelId": "mh_002",
    "propertyType": "Resort",
    "isActive": true,
    "subscriptionPurchaseId": "sub_002",
    "subscriptionName": "Silver Plan",
    "subscriptionStart": 1737901000000,
    "subscriptionEnd": 1769437000000,
    "logoUrl": "https://picsum.photos/100/100?random=2",
    "lastSync": 1738001000000,
    "hotelImageUrl": "https://picsum.photos/200/100?random=2",
    "addressModel": {
      "addressLine1": "45 Beach Road",
      "addressLine2": "Near Lighthouse",
      "city": "Goa",
      "state": "Goa",
      "country": "India",
      "postalCode": "403001",
    },
    "otherDocuments": {"license": "https://example.com/license2.pdf"},
    "totalUser": 18,
    "totaltask": 65,
    "totalRevenue": 980000,
  },
  {
    "name": "Skyline Inn",
    "clientId": "16lqKKrDMVmmaC7XtogQ",
    "floors": {"1": 10, "2": 9},
    "createdAt": 1737902000000,
    "updatedAt": 1738002000000,
    "masterHotelId": "mh_003",
    "propertyType": "Business",
    "isActive": true,
    "subscriptionPurchaseId": "sub_003",
    "subscriptionName": "Platinum Plan",
    "subscriptionStart": 1737902000000,
    "subscriptionEnd": 1769438000000,
    "logoUrl": "https://picsum.photos/100/100?random=3",
    "lastSync": 1738002000000,
    "hotelImageUrl": "https://picsum.photos/200/100?random=3",
    "addressModel": {
      "addressLine1": "789 Skyline Towers",
      "addressLine2": "Business District",
      "city": "Delhi",
      "state": "Delhi",
      "country": "India",
      "postalCode": "110001",
    },
    "otherDocuments": {"license": "https://example.com/license3.pdf"},
    "totalUser": 30,
    "totaltask": 120,
    "totalRevenue": 2100000,
  },
  {
    "name": "Mountain View Retreat",
    "clientId": "1LK7NQ6VEVRQ5XeJPwH5",
    "floors": {"1": 8, "2": 8},
    "createdAt": 1737903000000,
    "updatedAt": 1738003000000,
    "masterHotelId": "mh_004",
    "propertyType": "Boutique",
    "isActive": false,
    "subscriptionPurchaseId": "sub_004",
    "subscriptionName": "Basic Plan",
    "subscriptionStart": 1737903000000,
    "subscriptionEnd": 1769439000000,
    "logoUrl": "https://picsum.photos/100/100?random=4",
    "lastSync": 1738003000000,
    "hotelImageUrl": "https://picsum.photos/200/100?random=4",
    "addressModel": {
      "addressLine1": "Hill Road",
      "addressLine2": "Near Mountain Peak",
      "city": "Manali",
      "state": "Himachal Pradesh",
      "country": "India",
      "postalCode": "175131",
    },
    "otherDocuments": {"license": "https://example.com/license4.pdf"},
    "totalUser": 10,
    "totaltask": 45,
    "totalRevenue": 500000,
  },
  {
    "name": "Royal Heritage Hotel",
    "clientId": "1UHim67BehZsf4xxiki0TT4krqz2",
    "floors": {"1": 20, "2": 18, "3": 15, "4": 12},
    "createdAt": 1737904000000,
    "updatedAt": 1738004000000,
    "masterHotelId": "mh_005",
    "propertyType": "Heritage",
    "isActive": true,
    "subscriptionPurchaseId": "sub_005",
    "subscriptionName": "Gold Plan",
    "subscriptionStart": 1737904000000,
    "subscriptionEnd": 1769440000000,
    "logoUrl": "https://picsum.photos/100/100?random=5",
    "lastSync": 1738004000000,
    "hotelImageUrl": "https://picsum.photos/200/100?random=5",
    "addressModel": {
      "addressLine1": "Heritage Road",
      "addressLine2": "Near City Palace",
      "city": "Jaipur",
      "state": "Rajasthan",
      "country": "India",
      "postalCode": "302001",
    },
    "otherDocuments": {"license": "https://example.com/license5.pdf"},
    "totalUser": 50,
    "totaltask": 200,
    "totalRevenue": 5000000,
  },
  {
    "name": "Oceanic Paradise",
    "clientId": "1qBaYF2gEC6hvmvmlz8N",
    "floors": {"1": 12, "2": 12, "3": 10},
    "createdAt": 1737905000000,
    "updatedAt": 1738005000000,
    "masterHotelId": "mh_006",
    "propertyType": "Resort",
    "isActive": true,
    "subscriptionPurchaseId": "sub_006",
    "subscriptionName": "Premium Plan",
    "subscriptionStart": 1737905000000,
    "subscriptionEnd": 1769441000000,
    "logoUrl": "https://picsum.photos/100/100?random=6",
    "lastSync": 1738005000000,
    "hotelImageUrl": "https://picsum.photos/200/100?random=6",
    "addressModel": {
      "addressLine1": "Palm Beach Street",
      "addressLine2": "Near Sea View",
      "city": "Goa",
      "state": "Goa",
      "country": "India",
      "postalCode": "403002",
    },
    "otherDocuments": {"license": "https://example.com/license6.pdf"},
    "totalUser": 28,
    "totaltask": 90,
    "totalRevenue": 1250000,
  },
  {
    "name": "Sunset Boulevard Hotel",
    "clientId": "AQbELnGttyxq4qtS3ROB",
    "floors": {"1": 10, "2": 9},
    "createdAt": 1737906000000,
    "updatedAt": 1738006000000,
    "masterHotelId": "mh_007",
    "propertyType": "Business",
    "isActive": true,
    "subscriptionPurchaseId": "sub_007",
    "subscriptionName": "Silver Plan",
    "subscriptionStart": 1737906000000,
    "subscriptionEnd": 1769442000000,
    "logoUrl": "https://picsum.photos/100/100?random=7",
    "lastSync": 1738006000000,
    "hotelImageUrl": "https://picsum.photos/200/100?random=7",
    "addressModel": {
      "addressLine1": "Boulevard Street",
      "addressLine2": "Downtown",
      "city": "Pune",
      "state": "Maharashtra",
      "country": "India",
      "postalCode": "411001",
    },
    "otherDocuments": {"license": "https://example.com/license7.pdf"},
    "totalUser": 20,
    "totaltask": 70,
    "totalRevenue": 900000,
  },
  {
    "name": "Royal Crown Hotel",
    "clientId": "G0xRZKqqsuYm7PgXKq5F",
    "floors": {"1": 18, "2": 15, "3": 12},
    "createdAt": 1737907000000,
    "updatedAt": 1738007000000,
    "masterHotelId": "mh_008",
    "propertyType": "Luxury",
    "isActive": true,
    "subscriptionPurchaseId": "sub_008",
    "subscriptionName": "Gold Plan",
    "subscriptionStart": 1737907000000,
    "subscriptionEnd": 1769443000000,
    "logoUrl": "https://picsum.photos/100/100?random=8",
    "lastSync": 1738007000000,
    "hotelImageUrl": "https://picsum.photos/200/100?random=8",
    "addressModel": {
      "addressLine1": "Crown Street",
      "addressLine2": "Near Mall",
      "city": "Bangalore",
      "state": "Karnataka",
      "country": "India",
      "postalCode": "560001",
    },
    "otherDocuments": {"license": "https://example.com/license8.pdf"},
    "totalUser": 40,
    "totaltask": 150,
    "totalRevenue": 3500000,
  },
];

/////////
///import 'dart:math';

// final List<String> hotelIds = [
//   "1pXsRBLGOOKbsCOyr9w7",
//   "FkLSSqfWcnbWw6lLiWJ7",
//   "PO4u5X67G4skSOzWU6xG",
//   "U563QAV89FOKXRw8ZGEX",
//   "WZx7K6yaoxAQNh686TQL",
//   "ZkUUxjAzB6cMq3c4nhga",
//   "jLtLrzPd3XjMekduITJV",
//   "vEypYc3dGDBps8bzScmt",
// ];

// final List<String> roles1 = ["rm", "gm", "dm", "operators"];

// final List<String> serviceTypes = ["Cleaning", "Check-in", "Repair", "Cooking"];

// final List<String> places = [
//   "Lobby",
//   "Room 101",
//   "Kitchen",
//   "Conference Hall",
//   "Gym",
// ];

// final Random random = Random();

// /// Generate 20 dummy tasks
// List<CommonTaskModel> generateDummyTasks() {
//   List<CommonTaskModel> tasks = [];

//   for (int i = 0; i < 20; i++) {
//     String hotelId = hotelIds[random.nextInt(hotelIds.length)];
//     String role = roles1[random.nextInt(roles1.length)];
//     String? dept = random.nextBool()
//         ? departments[random.nextInt(departments.length)]
//         : null;
//     String? service = random.nextBool()
//         ? serviceTypes[random.nextInt(serviceTypes.length)]
//         : null;
//     String frequency = frequencies[random.nextInt(frequencies.length)];
//     String place = places[random.nextInt(places.length)];

//     final createdAt = DateTime.now().subtract(
//       Duration(days: random.nextInt(1000)),
//     );
//     final updatedAt = createdAt.add(Duration(days: random.nextInt(30)));

//     CommonTaskModel task = CommonTaskModel(
//       docId: "", // Firestore will generate
//       taskId: "${role.toUpperCase()}${i + 1}",

//       title: "Task ${i + 1} for Hotel $hotelId",
//       desc: "Description for task ${i + 1}",
//       createdAt: createdAt,
//       createdByDocId: "system",
//       createdByName: "System",
//       updatedAt: updatedAt,
//       updatedBy: "system",
//       updatedByName: "System",

//       hotelId: hotelId,
//       assignedRole: role,
//       assignedDepartmentId: dept,
//       serviceType: service,
//       frequency: frequency,
//       dayOrDate: DateTime.now().add(Duration(days: i)).toIso8601String(),
//       duration: "${1 + random.nextInt(5)} hrs",
//       place: place,
//       questions: [
//         {"question": "Sample question 1", "type": "text"},
//         {"question": "Sample question 2", "type": "checkbox"},
//       ],
//       startDate: null,
//       endDate: null,
//       fromMasterHotel: false,
//       isActive: true,
//     );

//     tasks.add(task);
//   }

//   return tasks;
// }

// /// Function to send tasks to Firestore
// Future<void> sendTasksToFirestore() async {
//   final tasks = generateDummyTasks();
//   final collectionRef = FBFireStore.tasks;

//   for (var task in tasks) {
//     await collectionRef.add(task.toMap());
//   }

//   print("✅ 20 dummy tasks added to Firestore!");
// }

// Future<void> addDummyClients() async {
//   final firestore = FirebaseFirestore.instance;
//   final clientsRef = firestore.collection("clients");

//   // 🔹 Create 25 dummy clients
//   for (int i = 1; i <= 30; i++) {
//     final now = DateTime.now();
//     final random = Random();

//     final client = ClientModel(
//       docId: "", // Firestore will assign, we don’t need it here
//       name: "Client $i",
//       email: "client$i@example.com",
//       phone: "987654${1000 + i}",

//       createdAt: now,
//       updatedAt: now,
//       lastPaymentExpiry: now.add(Duration(days: 30 * (i % 12))),
//       lastLogin: i % 2 == 0 ? now.subtract(Duration(days: i)) : null,

//       status: (i % 3 == 0)
//           ? "inactive"
//           : (i % 5 == 0)
//           ? "suspended"
//           : "active",

//       totalHotels: random.nextInt(10),
//       totalRevenue: (1000 + random.nextInt(5000)) * 1.0,
//       isDeleted: false,
//     );

//     await clientsRef.add(client.toJson());
//   }

//   print("✅ 25 Dummy Clients Added to Firestore!");
// }
