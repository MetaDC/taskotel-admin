import 'package:equatable/equatable.dart';

class HotelEntity extends Equatable {
  final String id;
  final String name;
  final String clientId;
  final String clientName;
  final Map<String, int> floors; // floor number -> room count
  final DateTime createdAt;
  final DateTime updatedAt;
  final String masterHotelId;
  final String propertyType;
  final bool isActive;
  final String? subscriptionPurchaseId;
  final String? subscriptionName;
  final DateTime? subscriptionStart;
  final DateTime? subscriptionEnd;
  final String? logoUrl;
  final String? hotelImageUrl;
  final DateTime? lastSync;
  final AddressModel? address;
  final Map<String, String>? otherDocuments;
  final HotelPerformance? performance;

  const HotelEntity({
    required this.id,
    required this.name,
    required this.clientId,
    required this.clientName,
    required this.floors,
    required this.createdAt,
    required this.updatedAt,
    required this.masterHotelId,
    required this.propertyType,
    required this.isActive,
    this.subscriptionPurchaseId,
    this.subscriptionName,
    this.subscriptionStart,
    this.subscriptionEnd,
    this.logoUrl,
    this.hotelImageUrl,
    this.lastSync,
    this.address,
    this.otherDocuments,
    this.performance,
  });

  int get totalRooms => floors.values.fold(0, (sum, rooms) => sum + rooms);

  bool get hasActiveSubscription {
    if (subscriptionEnd == null) return false;
    return DateTime.now().isBefore(subscriptionEnd!);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        clientId,
        clientName,
        floors,
        createdAt,
        updatedAt,
        masterHotelId,
        propertyType,
        isActive,
        subscriptionPurchaseId,
        subscriptionName,
        subscriptionStart,
        subscriptionEnd,
        logoUrl,
        hotelImageUrl,
        lastSync,
        address,
        otherDocuments,
        performance,
      ];
}

class AddressModel extends Equatable {
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final double? latitude;
  final double? longitude;

  const AddressModel({
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        addressLine1,
        addressLine2,
        city,
        state,
        country,
        postalCode,
        latitude,
        longitude,
      ];
}

class HotelPerformance extends Equatable {
  final double taskCompletionRate;
  final double onTimeDeliveryRate;
  final double qualityScore;
  final int dailyActiveStaff;
  final double tasksPerDay;
  final int issuesResolved;
  final double revenueContribution;
  final double renewalRate;

  const HotelPerformance({
    required this.taskCompletionRate,
    required this.onTimeDeliveryRate,
    required this.qualityScore,
    required this.dailyActiveStaff,
    required this.tasksPerDay,
    required this.issuesResolved,
    required this.revenueContribution,
    required this.renewalRate,
  });

  @override
  List<Object?> get props => [
        taskCompletionRate,
        onTimeDeliveryRate,
        qualityScore,
        dailyActiveStaff,
        tasksPerDay,
        issuesResolved,
        revenueContribution,
        renewalRate,
      ];
}
