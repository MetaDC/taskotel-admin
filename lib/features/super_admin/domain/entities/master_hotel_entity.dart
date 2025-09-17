import 'package:equatable/equatable.dart';

class MasterHotelEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final String propertyType;
  final List<MasterDepartmentEntity> departments;
  final List<MasterTaskEntity> tasks;
  final int totalImports;
  final int activeImports;

  const MasterHotelEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.propertyType,
    required this.departments,
    required this.tasks,
    required this.totalImports,
    required this.activeImports,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        createdAt,
        updatedAt,
        isActive,
        propertyType,
        departments,
        tasks,
        totalImports,
        activeImports,
      ];

  MasterHotelEntity copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? propertyType,
    List<MasterDepartmentEntity>? departments,
    List<MasterTaskEntity>? tasks,
    int? totalImports,
    int? activeImports,
  }) {
    return MasterHotelEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      propertyType: propertyType ?? this.propertyType,
      departments: departments ?? this.departments,
      tasks: tasks ?? this.tasks,
      totalImports: totalImports ?? this.totalImports,
      activeImports: activeImports ?? this.activeImports,
    );
  }
}

class MasterDepartmentEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String masterHotelId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MasterDepartmentEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.masterHotelId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        masterHotelId,
        isActive,
        createdAt,
        updatedAt,
      ];

  MasterDepartmentEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? masterHotelId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MasterDepartmentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      masterHotelId: masterHotelId ?? this.masterHotelId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class MasterTaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String createdById;
  final String createdByName;
  final DateTime updatedAt;
  final String updatedById;
  final String updatedByName;
  final int duration; // in minutes
  final String place;
  final List<TaskQuestion> questions;
  final String? departmentId;
  final String masterHotelId;
  final String assignedRole;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String serviceType;
  final TaskFrequency frequency;
  final String dayOrDate;
  final bool isActive;

  const MasterTaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.createdById,
    required this.createdByName,
    required this.updatedAt,
    required this.updatedById,
    required this.updatedByName,
    required this.duration,
    required this.place,
    required this.questions,
    this.departmentId,
    required this.masterHotelId,
    required this.assignedRole,
    this.startedAt,
    this.endedAt,
    required this.serviceType,
    required this.frequency,
    required this.dayOrDate,
    required this.isActive,
  });

  bool get isDepartmentSpecific => departmentId != null;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        createdAt,
        createdById,
        createdByName,
        updatedAt,
        updatedById,
        updatedByName,
        duration,
        place,
        questions,
        departmentId,
        masterHotelId,
        assignedRole,
        startedAt,
        endedAt,
        serviceType,
        frequency,
        dayOrDate,
        isActive,
      ];
}

class TaskQuestion extends Equatable {
  final String questionId;
  final String questionText;
  final QuestionType questionType;
  final List<String> options;
  final bool isRequired;

  const TaskQuestion({
    required this.questionId,
    required this.questionText,
    required this.questionType,
    required this.options,
    required this.isRequired,
  });

  @override
  List<Object?> get props => [
        questionId,
        questionText,
        questionType,
        options,
        isRequired,
      ];
}

enum QuestionType {
  text,
  multipleChoice,
  checkbox,
  rating,
  yesNo,
}

enum TaskFrequency {
  daily,
  weekly,
  monthly,
  yearly,
  custom,
}

extension TaskFrequencyExtension on TaskFrequency {
  String get displayName {
    switch (this) {
      case TaskFrequency.daily:
        return 'Daily';
      case TaskFrequency.weekly:
        return 'Weekly';
      case TaskFrequency.monthly:
        return 'Monthly';
      case TaskFrequency.yearly:
        return 'Yearly';
      case TaskFrequency.custom:
        return 'Custom';
    }
  }

  String get value {
    switch (this) {
      case TaskFrequency.daily:
        return 'daily';
      case TaskFrequency.weekly:
        return 'weekly';
      case TaskFrequency.monthly:
        return 'monthly';
      case TaskFrequency.yearly:
        return 'yearly';
      case TaskFrequency.custom:
        return 'custom';
    }
  }

  static TaskFrequency fromString(String value) {
    switch (value.toLowerCase()) {
      case 'daily':
        return TaskFrequency.daily;
      case 'weekly':
        return TaskFrequency.weekly;
      case 'monthly':
        return TaskFrequency.monthly;
      case 'yearly':
        return TaskFrequency.yearly;
      case 'custom':
        return TaskFrequency.custom;
      default:
        return TaskFrequency.daily;
    }
  }
}
