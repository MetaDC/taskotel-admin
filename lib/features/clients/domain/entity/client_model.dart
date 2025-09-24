import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  final String docId; // Firestore document ID
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;
  final String status; // active | inactive | suspended etc.
  final DateTime lastPaymentExpiry;
  final DateTime updatedAt;
  final DateTime? lastLogin;
  final int totalHotels; // current hotel count
  final double totalRevenue; // generated revenue

  ClientModel({
    required this.docId,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.status,
    required this.updatedAt,
    required this.lastPaymentExpiry,
    this.lastLogin,
    required this.totalHotels,
    required this.totalRevenue,
  });

  /// 🔹 Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "status": status,
      "lastPaymentExpiry": lastPaymentExpiry.millisecondsSinceEpoch,
      "updatedAt": updatedAt.millisecondsSinceEpoch,
      "lastLogin": lastLogin?.millisecondsSinceEpoch,
      "totalHotels": totalHotels,
      "totalRevenue": totalRevenue,
    };
  }

  /// 🔹 Create model from JSON map
  factory ClientModel.fromJson(Map<String, dynamic> json, String docId) {
    return ClientModel(
      docId: docId,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      lastPaymentExpiry: DateTime.fromMillisecondsSinceEpoch(
        json['lastPaymentExpiry'],
      ),
      status: json["status"] ?? "active",

      lastLogin: json["lastLogin"] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastLogin'])
          : null,
      totalHotels: json["totalHotels"] ?? 0,
      totalRevenue: (json["totalRevenue"] ?? 0).toDouble(),
    );
  }

  /// 🔹 From Firestore DocumentSnapshot
  factory ClientModel.fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data()!;
    return ClientModel(
      docId: snap.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updatedAt']),
      lastPaymentExpiry: DateTime.fromMillisecondsSinceEpoch(
        data['lastPaymentExpiry'],
      ),
      status: data['status'] ?? 'active',

      lastLogin: data['lastLogin'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['lastLogin'])
          : null,
      totalHotels: data['totalHotels'] ?? 0,
      totalRevenue: (data['totalRevenue'] ?? 0).toDouble(),
    );
  }

  /// 🔹 From Firestore QueryDocumentSnapshot
  factory ClientModel.fromDocSnap(
    QueryDocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data();

    return ClientModel(
      docId: snap.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updatedAt']),
      lastPaymentExpiry: DateTime.fromMillisecondsSinceEpoch(
        data['lastPaymentExpiry'],
      ),
      status: data['status'] ?? 'active',

      lastLogin: data['lastLogin'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['lastLogin'])
          : null,
      totalHotels: data['totalHotels'] ?? 0,
      totalRevenue: (data['totalRevenue'] ?? 0).toDouble(),
    );
  }

  /// 🔹 CopyWith for updating specific fields
  ClientModel copyWith({
    String? name,
    String? email,
    String? phone,
    DateTime? createdAt,
    String? status,
    DateTime? updatedAt,
    DateTime? lastPaymentExpiry,
    DateTime? lastLogin,
    int? totalHotels,
    double? totalRevenue,
  }) {
    return ClientModel(
      docId: docId, // docId never changes
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      lastPaymentExpiry: lastPaymentExpiry ?? this.lastPaymentExpiry,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
      totalHotels: totalHotels ?? this.totalHotels,
      totalRevenue: totalRevenue ?? this.totalRevenue,
    );
  }
}
