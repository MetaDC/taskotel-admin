import 'package:cloud_firestore/cloud_firestore.dart';

class MasterHotelModel {
  final String docId;
  final String franchiseName;
  final String propertyType;
  final String description;
  final List<String> amenities;
  final String? logoUrl;
  final String? logoName;
  final String? logoExtension;
  final String? websiteUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final int totalClients;
  final int totalMasterTasks;

  MasterHotelModel({
    required this.docId,
    required this.franchiseName,
    required this.propertyType,
    required this.description,
    required this.amenities,
    this.logoUrl,
    this.logoName,
    this.logoExtension,
    this.websiteUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.totalClients,
    required this.totalMasterTasks,
  });

  factory MasterHotelModel.fromJson(Map<String, dynamic> json) {
    return MasterHotelModel(
      docId: json['docId'] ?? '',
      franchiseName: json['franchiseName'] ?? json['name'] ?? '',
      propertyType: json['propertyType'] ?? '',
      description: json['description'] ?? '',
      amenities: List<String>.from(json['amenities'] ?? []),
      logoUrl: json['logoUrl'],
      logoName: json['logoName'],
      logoExtension: json['logoExtension'],
      websiteUrl: json['websiteUrl'],
      createdAt: (json['createdAt'] is Timestamp)
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: (json['updatedAt'] is Timestamp)
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      isActive: json['isActive'] ?? false,
      totalClients: json['totalClients'] ?? 0,
      totalMasterTasks: json['totalMasterTasks'] ?? 0,
    );
  }

  factory MasterHotelModel.fromDocSnap(DocumentSnapshot docSnap) {
    final data = docSnap.data() as Map<String, dynamic>;
    return MasterHotelModel.fromJson({...data, 'docId': docSnap.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'franchiseName': franchiseName,
      'propertyType': propertyType,
      'description': description,
      'amenities': amenities,
      'logoUrl': logoUrl,
      'logoName': logoName,
      'logoExtension': logoExtension,

      'websiteUrl': websiteUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isActive': isActive,
      'totalClients': totalClients,
      'totalMasterTasks': totalMasterTasks,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  MasterHotelModel copyWith({
    String? docId,
    String? franchiseName,
    String? propertyType,
    String? description,
    List<String>? amenities,
    String? logoUrl,
    String? logoName,
    String? logoExtension,
    String? websiteUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    int? totalClients,
    int? totalMasterTasks,
  }) {
    return MasterHotelModel(
      docId: docId ?? this.docId,
      franchiseName: franchiseName ?? this.franchiseName,
      propertyType: propertyType ?? this.propertyType,
      description: description ?? this.description,
      amenities: amenities ?? this.amenities,
      logoUrl: logoUrl ?? this.logoUrl,
      logoName: logoName ?? this.logoName,
      logoExtension: logoExtension ?? this.logoExtension,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      totalClients: totalClients ?? this.totalClients,
      totalMasterTasks: totalMasterTasks ?? this.totalMasterTasks,
    );
  }
}
