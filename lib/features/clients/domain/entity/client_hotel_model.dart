import 'package:cloud_firestore/cloud_firestore.dart';

class ClientHotelModel {
  final String docId;
  final String name;
  final String clientId;
  final Map<String, int> floors; // floor number -> room count
  final DateTime createdAt;
  final DateTime updatedAt;
  final String masterHotelId; // Reference to master hotel template
  final String propertyType;
  final bool isActive;
  final String subscriptionPurchaseId;
  final String subscriptionName;
  final DateTime subscriptionStart;
  final DateTime subscriptionEnd;
  final String? logoUrl;
  final DateTime? lastSync;
  final String? hotelImageUrl;
  final AddressModel addressModel;
  final int totalTasks;
  final int completedTasks;
  final double completionRate;

  ClientHotelModel({
    required this.docId,
    required this.name,
    required this.clientId,
    required this.floors,
    required this.createdAt,
    required this.updatedAt,
    required this.masterHotelId,
    required this.propertyType,
    required this.isActive,
    required this.subscriptionPurchaseId,
    required this.subscriptionName,
    required this.subscriptionStart,
    required this.subscriptionEnd,
    this.logoUrl,
    this.lastSync,
    this.hotelImageUrl,
    required this.addressModel,
    required this.totalTasks,
    required this.completedTasks,
    required this.completionRate,
  });

  factory ClientHotelModel.fromJson(Map<String, dynamic> json, String docId) {
    return ClientHotelModel(
      docId: docId,
      name: json['name'] ?? '',
      clientId: json['clientId'] ?? '',
      floors: Map<String, int>.from(json['floors'] ?? {}),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      masterHotelId: json['masterHotelId'] ?? '',
      propertyType: json['propertyType'] ?? '',
      isActive: json['isActive'] ?? true,
      subscriptionPurchaseId: json['subscriptionPurchaseId'] ?? '',
      subscriptionName: json['subscriptionName'] ?? '',
      subscriptionStart: DateTime.fromMillisecondsSinceEpoch(json['subscriptionStart']),
      subscriptionEnd: DateTime.fromMillisecondsSinceEpoch(json['subscriptionEnd']),
      logoUrl: json['logoUrl'],
      lastSync: json['lastSync'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['lastSync'])
          : null,
      hotelImageUrl: json['hotelImageUrl'],
      addressModel: AddressModel.fromJson(json['addressModel'] ?? {}),
      totalTasks: json['totalTasks'] ?? 0,
      completedTasks: json['completedTasks'] ?? 0,
      completionRate: (json['completionRate'] ?? 0.0).toDouble(),
    );
  }

  factory ClientHotelModel.fromDocSnap(QueryDocumentSnapshot<Map<String, dynamic>> snap) {
    return ClientHotelModel.fromJson(snap.data(), snap.id);
  }

  factory ClientHotelModel.fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data()!;
    return ClientHotelModel.fromJson(data, snap.id);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'clientId': clientId,
      'floors': floors,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'masterHotelId': masterHotelId,
      'propertyType': propertyType,
      'isActive': isActive,
      'subscriptionPurchaseId': subscriptionPurchaseId,
      'subscriptionName': subscriptionName,
      'subscriptionStart': subscriptionStart.millisecondsSinceEpoch,
      'subscriptionEnd': subscriptionEnd.millisecondsSinceEpoch,
      'logoUrl': logoUrl,
      'lastSync': lastSync?.millisecondsSinceEpoch,
      'hotelImageUrl': hotelImageUrl,
      'addressModel': addressModel.toJson(),
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'completionRate': completionRate,
    };
  }

  ClientHotelModel copyWith({
    String? name,
    String? clientId,
    Map<String, int>? floors,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? masterHotelId,
    String? propertyType,
    bool? isActive,
    String? subscriptionPurchaseId,
    String? subscriptionName,
    DateTime? subscriptionStart,
    DateTime? subscriptionEnd,
    String? logoUrl,
    DateTime? lastSync,
    String? hotelImageUrl,
    AddressModel? addressModel,
    int? totalTasks,
    int? completedTasks,
    double? completionRate,
  }) {
    return ClientHotelModel(
      docId: docId,
      name: name ?? this.name,
      clientId: clientId ?? this.clientId,
      floors: floors ?? this.floors,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      masterHotelId: masterHotelId ?? this.masterHotelId,
      propertyType: propertyType ?? this.propertyType,
      isActive: isActive ?? this.isActive,
      subscriptionPurchaseId: subscriptionPurchaseId ?? this.subscriptionPurchaseId,
      subscriptionName: subscriptionName ?? this.subscriptionName,
      subscriptionStart: subscriptionStart ?? this.subscriptionStart,
      subscriptionEnd: subscriptionEnd ?? this.subscriptionEnd,
      logoUrl: logoUrl ?? this.logoUrl,
      lastSync: lastSync ?? this.lastSync,
      hotelImageUrl: hotelImageUrl ?? this.hotelImageUrl,
      addressModel: addressModel ?? this.addressModel,
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      completionRate: completionRate ?? this.completionRate,
    );
  }
}

class AddressModel {
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final double latitude;
  final double longitude;

  AddressModel({
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postalCode'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
