import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  String docId;
  String name;
  String email;
  String phone;
  DateTime createdAt;
  String status;
  DateTime hotelExpireDate;
  DateTime updatedAt;
  DateTime lastLogin;
  double totalRevenue;

  ClientModel({
    required this.docId,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.status,
    required this.hotelExpireDate,
    required this.updatedAt,
    required this.lastLogin,
    required this.totalRevenue,
  });

  // Create from JSON map
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      docId: json['docId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      status: json['status'] ?? '',
      hotelExpireDate: (json['hotelExpireDate'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      lastLogin: (json['lastLogin'] as Timestamp).toDate(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
    );
  }

  // Create from DocumentSnapshot
  factory ClientModel.fromDocSnap(DocumentSnapshot docSnap) {
    final data = docSnap.data() as Map<String, dynamic>;
    return ClientModel.fromJson({
      ...data,
      'docId': docSnap.id, // Ensure docId is set from snapshot ID
    });
  }

  // Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
      'hotelExpireDate': Timestamp.fromDate(hotelExpireDate),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastLogin': Timestamp.fromDate(lastLogin),
      'totalRevenue': totalRevenue,
    };
  }

  // Convert to Map (optional helper if needed, same as toJson in most cases)
  Map<String, dynamic> toMap() => toJson();
}
