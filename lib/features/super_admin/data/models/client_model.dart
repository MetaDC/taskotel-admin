import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/client_entity.dart';

class ClientModel extends ClientEntity {
  const ClientModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.companyName,
    required super.createdAt,
    required super.updatedAt,
    super.lastLogin,
    required super.status,
    required super.totalHotels,
    required super.totalRooms,
    required super.totalRevenue,
    required super.isTrialAccount,
    super.trialEndDate,
  });

  factory ClientModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClientModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      companyName: data['companyName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastLogin: data['lastLogin'] != null
          ? (data['lastLogin'] as Timestamp).toDate()
          : null,
      status: ClientStatusExtension.fromString(data['status'] ?? 'active'),
      totalHotels: data['totalHotels'] ?? 0,
      totalRooms: data['totalRooms'] ?? 0,
      totalRevenue: (data['totalRevenue'] ?? 0.0).toDouble(),
      isTrialAccount: data['isTrialAccount'] ?? false,
      trialEndDate: data['trialEndDate'] != null
          ? (data['trialEndDate'] as Timestamp).toDate()
          : null,
    );
  }

  factory ClientModel.fromEntity(ClientEntity entity) {
    return ClientModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      companyName: entity.companyName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastLogin: entity.lastLogin,
      status: entity.status,
      totalHotels: entity.totalHotels,
      totalRooms: entity.totalRooms,
      totalRevenue: entity.totalRevenue,
      isTrialAccount: entity.isTrialAccount,
      trialEndDate: entity.trialEndDate,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'companyName': companyName,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'status': status.value,
      'totalHotels': totalHotels,
      'totalRooms': totalRooms,
      'totalRevenue': totalRevenue,
      'isTrialAccount': isTrialAccount,
      'trialEndDate':
          trialEndDate != null ? Timestamp.fromDate(trialEndDate!) : null,
    };
  }

  ClientModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? companyName,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
    ClientStatus? status,
    int? totalHotels,
    int? totalRooms,
    double? totalRevenue,
    bool? isTrialAccount,
    DateTime? trialEndDate,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      companyName: companyName ?? this.companyName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
      status: status ?? this.status,
      totalHotels: totalHotels ?? this.totalHotels,
      totalRooms: totalRooms ?? this.totalRooms,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      isTrialAccount: isTrialAccount ?? this.isTrialAccount,
      trialEndDate: trialEndDate ?? this.trialEndDate,
    );
  }
}
