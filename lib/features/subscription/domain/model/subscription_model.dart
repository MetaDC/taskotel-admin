import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionPlanModel {
  String docId;
  String title;
  String desc;
  int minRooms;
  int maxRooms;
  Map<String, double> price; // { "monthly": double, "yearly": double }
  List<String> features;
  bool isActive;
  int totalSubScribers;
  double totalRevenue;
  bool forGeneral;
  DateTime createdAt;
  DateTime updatedAt;

  SubscriptionPlanModel({
    required this.docId,
    required this.title,
    required this.desc,
    required this.minRooms,
    required this.maxRooms,
    required this.price,
    required this.features,
    required this.isActive,
    required this.totalSubScribers,
    required this.totalRevenue,
    required this.forGeneral,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 🔹 Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': desc,
      'minRooms': minRooms,
      'maxRooms': maxRooms,
      'price': {'monthly': price['monthly'], 'yearly': price['yearly']},
      'features': features,
      'isActive': isActive,
      'totalSubScribers': totalSubScribers,
      'totalRevenue': totalRevenue,
      'forGeneral': forGeneral,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  /// 🔹 Create model from JSON map
  factory SubscriptionPlanModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    return SubscriptionPlanModel(
      docId: docId,
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      minRooms: (json['minRooms'] as num?)?.toInt() ?? 0,
      maxRooms: (json['maxRooms'] as num?)?.toInt() ?? 0,
      price: {
        'monthly': (json['price']?['monthly'] ?? 0).toDouble(),
        'yearly': (json['price']?['yearly'] ?? 0).toDouble(),
      },
      features: List<String>.from(json['features'] ?? []),
      isActive: json['isActive'] ?? false,
      totalSubScribers: (json['totalSubScribers'] ?? 0).toInt(),
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      forGeneral: json['forGeneral'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }

  /// 🔹 From Firestore DocumentSnapshot
  factory SubscriptionPlanModel.fromSnap(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data()!;
    return SubscriptionPlanModel.fromJson(data, snap.id);
  }

  /// 🔹 From Firestore QueryDocumentSnapshot
  factory SubscriptionPlanModel.fromDocSnap(
    QueryDocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data();
    return SubscriptionPlanModel.fromJson(data, snap.id);
  }

  // toMap
  Map<String, dynamic> toMap() => toJson();

  /// 🔹 CopyWith for updating specific fields
  
}
