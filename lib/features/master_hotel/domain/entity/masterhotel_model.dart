import 'package:cloud_firestore/cloud_firestore.dart';

class MasterHotelModel {
  final String docId;
  final String franchiseName;
  final String description;
  final List<String> amenities;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String propertyType;
  final bool isActive;

  MasterHotelModel({
    required this.docId,
    required this.franchiseName,
    required this.description,
    required this.amenities,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.propertyType,
  });

  factory MasterHotelModel.fromJson(Map<String, dynamic> json) {
    return MasterHotelModel(
      docId: json['docId'] ?? '',
      franchiseName: json['name'] ?? '',
      description: json['description'] ?? '',
      amenities: List<String>.from(json['amenities'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      isActive: json['isActive'] ?? false,
      propertyType: json['propertyType'] ?? '',
    );
  }

  factory MasterHotelModel.fromDocSnap(DocumentSnapshot docSnap) {
    final data = docSnap.data() as Map<String, dynamic>;
    return MasterHotelModel.fromJson({...data, 'docId': docSnap.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'name': franchiseName,
      'description': description,
      'amenities': amenities,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
      'propertyType': propertyType,
    };
  }

  Map<String, dynamic> toMap() => toJson();
}
