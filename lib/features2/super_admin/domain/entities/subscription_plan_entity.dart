import 'package:equatable/equatable.dart';

class SubscriptionPlanEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final int minRooms;
  final int maxRooms;
  final PricingModel pricing;
  final List<String> features;
  final bool isActive;
  final int totalSubscribers;
  final double totalRevenue;
  final bool forGeneral;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubscriptionPlanEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.minRooms,
    required this.maxRooms,
    required this.pricing,
    required this.features,
    required this.isActive,
    required this.totalSubscribers,
    required this.totalRevenue,
    required this.forGeneral,
    required this.createdAt,
    required this.updatedAt,
  });

  String get roomRange => '$minRooms-$maxRooms rooms';

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        minRooms,
        maxRooms,
        pricing,
        features,
        isActive,
        totalSubscribers,
        totalRevenue,
        forGeneral,
        createdAt,
        updatedAt,
      ];

  SubscriptionPlanEntity copyWith({
    String? id,
    String? title,
    String? description,
    int? minRooms,
    int? maxRooms,
    PricingModel? pricing,
    List<String>? features,
    bool? isActive,
    int? totalSubscribers,
    double? totalRevenue,
    bool? forGeneral,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionPlanEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      minRooms: minRooms ?? this.minRooms,
      maxRooms: maxRooms ?? this.maxRooms,
      pricing: pricing ?? this.pricing,
      features: features ?? this.features,
      isActive: isActive ?? this.isActive,
      totalSubscribers: totalSubscribers ?? this.totalSubscribers,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      forGeneral: forGeneral ?? this.forGeneral,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PricingModel extends Equatable {
  final double monthly;
  final double yearly;

  const PricingModel({
    required this.monthly,
    required this.yearly,
  });

  double get yearlyDiscount => ((monthly * 12 - yearly) / (monthly * 12)) * 100;

  @override
  List<Object?> get props => [monthly, yearly];

  PricingModel copyWith({
    double? monthly,
    double? yearly,
  }) {
    return PricingModel(
      monthly: monthly ?? this.monthly,
      yearly: yearly ?? this.yearly,
    );
  }
}
