import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features/subscription/domain/model/subscription_model.dart';

class ClientPlanModel {
  final String docId; // Firestore ID
  final String clientId;
  final String clientName;
  final String email;


  /// Type of plan assigned
  final String planType; // "trial" | "gift"

  /// Reference to existing subscription plan
  final String planId;
  final SubscriptionPlanModel planDetails;

  /// For gift or trial limits
  final int allowedHotels; // how many hotels can use this plan
  final int usedHotels; // how many hotels already applied it

  /// Dates
  final int duration; // in days
  final DateTime? redeemStartAt; // when first applied to a hotel
  final DateTime? redeemEndAt; // if limited duration (for trial)

  /// Metadata
  final String assignedBy; // admin id who gave it (for tracking)
  final bool isActive;

  ClientPlanModel({
    required this.docId,
    required this.clientId,
    required this.clientName,
    required this.email,
    required this.planType,
    required this.planId,
    required this.planDetails,
    required this.allowedHotels,
    required this.usedHotels,
    required this.duration,
    this.redeemStartAt, // when first applied to a hotel
    this.redeemEndAt, // if limited duration (for trial)
    required this.assignedBy,
    required this.isActive,
  });

  factory ClientPlanModel.fromDocSnap(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return ClientPlanModel(
      docId: doc.id,
      clientId: data['clientId'] ?? '',
      clientName: data['clientName'] ?? '',
      email: data['email'] ?? '',
      planType: data['planType'] ?? '',
      planId: data['planId'] ?? '',
      planDetails: SubscriptionPlanModel.fromJson(
        (data['planDetails']),
        'Need to change',
      ),
      allowedHotels: (data['allowedHotels'] ?? 0).toInt(),
      usedHotels: (data['usedHotels'] ?? 0).toInt(),
      duration: (data['duration'] ?? 0).toInt(),
      redeemStartAt: data['redeemStartAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['redeemStartAt'])
          : null,
      redeemEndAt: data['redeemEndAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['redeemEndAt'])
          : null,
      assignedBy: data['assignedBy'] ?? '',
      isActive: data['isActive'] ?? false,
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'email': email,
      'planType': planType,
      'planId': planId,
      'planDetails': planDetails.toMap(),
      'allowedHotels': allowedHotels,
      'usedHotels': usedHotels,
      'duration': duration,
      'redeemStartAt': redeemStartAt?.millisecondsSinceEpoch,
      'redeemEndAt': redeemEndAt?.millisecondsSinceEpoch,
      'assignedBy': assignedBy,
      'isActive': isActive,
    };
  }

  // toMap
  Map<String, dynamic> toMap() => toJson();

  //form json
  factory ClientPlanModel.fromJson(Map<String, dynamic> json, String docId) {
    return ClientPlanModel(
      docId: docId,
      clientId: json['clientId'] ?? '',
      clientName: json['clientName'] ?? '',
      email: json['email'] ?? '',
      planType: json['planType'] ?? '',
      planId: json['planId'] ?? '',
      planDetails: SubscriptionPlanModel.fromJson(
        (json['planDetails']),
        'Need to change',
      ),
      allowedHotels: (json['allowedHotels'] ?? 0).toInt(),
      usedHotels: (json['usedHotels'] ?? 0).toInt(),
      duration: (json['duration'] ?? 0).toInt(),
      redeemStartAt: json['redeemStartAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['redeemStartAt'])
          : null,
      redeemEndAt: json['redeemEndAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['redeemEndAt'])
          : null,
      assignedBy: json['assignedBy'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}
