import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/subscription_plan_entity.dart';

class SubscriptionPlanModel extends SubscriptionPlanEntity {
  const SubscriptionPlanModel({
    required super.id,
    required super.title,
    required super.description,
    required super.minRooms,
    required super.maxRooms,
    required super.pricing,
    required super.features,
    required super.isActive,
    required super.totalSubscribers,
    required super.totalRevenue,
    required super.forGeneral,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SubscriptionPlanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubscriptionPlanModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['desc'] ?? '',
      minRooms: data['minRooms'] ?? 0,
      maxRooms: data['maxRooms'] ?? 0,
      pricing: PricingModelData.fromMap(data['price'] ?? {}),
      features: List<String>.from(data['features'] ?? []),
      isActive: data['isActive'] ?? true,
      totalSubscribers: data['totalSubScribers'] ?? 0,
      totalRevenue: (data['totalRevenue'] ?? 0.0).toDouble(),
      forGeneral: data['forGeneral'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory SubscriptionPlanModel.fromEntity(SubscriptionPlanEntity entity) {
    return SubscriptionPlanModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      minRooms: entity.minRooms,
      maxRooms: entity.maxRooms,
      pricing: entity.pricing,
      features: entity.features,
      isActive: entity.isActive,
      totalSubscribers: entity.totalSubscribers,
      totalRevenue: entity.totalRevenue,
      forGeneral: entity.forGeneral,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'desc': description,
      'minRooms': minRooms,
      'maxRooms': maxRooms,
      'price': {
        'monthly': pricing.monthly,
        'yearly': pricing.yearly,
      },
      'features': features,
      'isActive': isActive,
      'totalSubScribers': totalSubscribers,
      'totalRevenue': totalRevenue,
      'forGeneral': forGeneral,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  SubscriptionPlanModel copyWith({
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
    return SubscriptionPlanModel(
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

class PricingModelData extends PricingModel {
  const PricingModelData({
    required super.monthly,
    required super.yearly,
  });

  factory PricingModelData.fromMap(Map<String, dynamic> map) {
    return PricingModelData(
      monthly: (map['monthly'] ?? 0.0).toDouble(),
      yearly: (map['yearly'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'monthly': monthly,
      'yearly': yearly,
    };
  }
}
