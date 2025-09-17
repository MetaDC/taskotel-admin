import 'package:equatable/equatable.dart';

class ClientEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String companyName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;
  final ClientStatus status;
  final int totalHotels;
  final int totalRooms;
  final double totalRevenue;
  final bool isTrialAccount;
  final DateTime? trialEndDate;

  const ClientEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.companyName,
    required this.createdAt,
    required this.updatedAt,
    this.lastLogin,
    required this.status,
    required this.totalHotels,
    required this.totalRooms,
    required this.totalRevenue,
    required this.isTrialAccount,
    this.trialEndDate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        companyName,
        createdAt,
        updatedAt,
        lastLogin,
        status,
        totalHotels,
        totalRooms,
        totalRevenue,
        isTrialAccount,
        trialEndDate,
      ];

  ClientEntity copyWith({
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
    return ClientEntity(
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

enum ClientStatus {
  active,
  expired,
  churned,
  trial,
}

extension ClientStatusExtension on ClientStatus {
  String get displayName {
    switch (this) {
      case ClientStatus.active:
        return 'Active';
      case ClientStatus.expired:
        return 'Expired';
      case ClientStatus.churned:
        return 'Churned';
      case ClientStatus.trial:
        return 'Trial';
    }
  }

  String get value {
    switch (this) {
      case ClientStatus.active:
        return 'active';
      case ClientStatus.expired:
        return 'expired';
      case ClientStatus.churned:
        return 'churned';
      case ClientStatus.trial:
        return 'trial';
    }
  }

  static ClientStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return ClientStatus.active;
      case 'expired':
        return ClientStatus.expired;
      case 'churned':
        return ClientStatus.churned;
      case 'trial':
        return ClientStatus.trial;
      default:
        return ClientStatus.active;
    }
  }
}
