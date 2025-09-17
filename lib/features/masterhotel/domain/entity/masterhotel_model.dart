import 'package:cloud_firestore/cloud_firestore.dart';

class MasterHotelModel {
  String docId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  bool isActive;
  String propertyType;

  MasterHotelModel({
    required this.docId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.propertyType,
  });

  factory MasterHotelModel.fromJson(Map<String, dynamic> json) {
    return MasterHotelModel(
      docId: json['docId'] ?? '',
      name: json['name'] ?? '',
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
      'docId': docId,
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
      'propertyType': propertyType,
    };
  }

  Map<String, dynamic> toMap() => toJson();
}
