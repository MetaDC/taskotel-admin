import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features/clients/domain/entity/address_model.dart';

class HotelModel {
  final String docId;
  final String name;
  final String clientId;
  final Map<int, int> floors;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? masterHotelId;
  final String propertyType;
  final bool isActive;
  final String subscriptionPurchaseId;
  final String subscriptionName;
  final DateTime subscriptionStart;
  final DateTime subscriptionEnd;
  final String logoUrl;
  final DateTime? lastSync;
  final String hotelImageUrl;
  final AddressModel addressModel;
  final Map<String, String> otherDocuments;
  final int totalUser;
  final int totaltask;
  final int totalRevenue;

  HotelModel({
    required this.docId,
    required this.name,
    required this.clientId,
    required this.floors,
    required this.createdAt,
    required this.updatedAt,
    this.masterHotelId,
    required this.propertyType,
    required this.isActive,
    required this.subscriptionPurchaseId,
    required this.subscriptionName,
    required this.subscriptionStart,
    required this.subscriptionEnd,
    required this.logoUrl,
    this.lastSync,
    required this.hotelImageUrl,
    required this.addressModel,
    required this.otherDocuments,
    required this.totalUser,
    required this.totaltask,
    required this.totalRevenue,
  });

  /// 🔄 Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "clientId": clientId,
      "floors": floors.map((k, v) => MapEntry(k.toString(), v)),
      "createdAt": createdAt.millisecondsSinceEpoch,
      "updatedAt": updatedAt.millisecondsSinceEpoch,
      "masterHotelId": masterHotelId,
      "propertyType": propertyType,
      "isActive": isActive,
      "subscriptionPurchaseId": subscriptionPurchaseId,
      "subscriptionName": subscriptionName,
      "subscriptionStart": subscriptionStart.millisecondsSinceEpoch,
      "subscriptionEnd": subscriptionEnd.millisecondsSinceEpoch,
      "logoUrl": logoUrl,
      "lastSync": lastSync?.millisecondsSinceEpoch,
      "hotelImageUrl": hotelImageUrl,
      "addressModel": addressModel.toMap(),
      "otherDocuments": otherDocuments,
      "totalUser": totalUser,
      "totaltask": totaltask,
      "totalRevenue": totalRevenue,
    };
  }

  factory HotelModel.fromDocSnap(
    QueryDocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data();

    return HotelModel(
      docId: snap.id,
      name: data['name'],
      clientId: data['clientId'],
      floors: Map<int, int>.from(
        (data['floors'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(int.parse(k), v),
        ),
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updatedAt']),
      masterHotelId: data['masterHotelId'],
      propertyType: data['propertyType'],
      isActive: data['isActive'],
      subscriptionPurchaseId: data['subscriptionPurchaseId'],
      subscriptionName: data['subscriptionName'],
      subscriptionStart: DateTime.fromMillisecondsSinceEpoch(
        data['subscriptionStart'],
      ),
      subscriptionEnd: DateTime.fromMillisecondsSinceEpoch(
        data['subscriptionEnd'],
      ),
      logoUrl: data['logoUrl'],
      lastSync: data['lastSync'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['lastSync'])
          : null,
      hotelImageUrl: data['hotelImageUrl'],
      addressModel: AddressModel.fromMap(
        Map<String, dynamic>.from(data['addressModel']),
      ),
      otherDocuments: Map<String, String>.from(data['otherDocuments']),
      totalUser: data['totalUser'] ?? 0,
      totaltask: data['totaltask'] ?? 0,
      totalRevenue: data['totalRevenue'] ?? 0,
    );
  }

  factory HotelModel.fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    return HotelModel.fromDocSnap(
      snap as QueryDocumentSnapshot<Map<String, dynamic>>,
    );
  }

  HotelModel copyWith({
    String? name,
    String? clientId,
    Map<int, int>? floors,
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
    Map<String, String>? otherDocuments,
    int? totalUser,
    int? totaltask,
    int? totalRevenue,
  }) {
    return HotelModel(
      docId: docId,
      name: name ?? this.name,
      clientId: clientId ?? this.clientId,
      floors: floors ?? this.floors,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      masterHotelId: masterHotelId ?? this.masterHotelId,
      propertyType: propertyType ?? this.propertyType,
      isActive: isActive ?? this.isActive,
      subscriptionPurchaseId:
          subscriptionPurchaseId ?? this.subscriptionPurchaseId,
      subscriptionName: subscriptionName ?? this.subscriptionName,
      subscriptionStart: subscriptionStart ?? this.subscriptionStart,
      subscriptionEnd: subscriptionEnd ?? this.subscriptionEnd,
      logoUrl: logoUrl ?? this.logoUrl,
      lastSync: lastSync ?? this.lastSync,
      hotelImageUrl: hotelImageUrl ?? this.hotelImageUrl,
      addressModel: addressModel ?? this.addressModel,
      otherDocuments: otherDocuments ?? this.otherDocuments,
      totalUser: totalUser ?? this.totalUser,
      totaltask: totaltask ?? this.totaltask,
      totalRevenue: totalRevenue ?? this.totalRevenue,
    );
  }
}
