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

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      docId: json['docId'] ?? '',
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      minRooms: (json['minRooms'] as num).toInt(),
      maxRooms: (json['maxRooms'] as num).toInt(),
      price: {
        'monthly': (json['price']['monthly'] as num).toDouble(),
        'yearly': (json['price']['yearly'] as num).toDouble(),
      },
      features: List<String>.from(json['features'] ?? []),
      isActive: json['isActive'] ?? false,
      totalSubScribers: (json['totalSubScribers'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      forGeneral: json['forGeneral'] ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory SubscriptionPlanModel.fromDocSnap(DocumentSnapshot docSnap) {
    final data = docSnap.data() as Map<String, dynamic>;
    return SubscriptionPlanModel.fromJson({...data, 'docId': docSnap.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
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
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Map<String, dynamic> toMap() => toJson();
}
