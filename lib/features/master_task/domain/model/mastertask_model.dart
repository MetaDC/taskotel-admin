import 'package:cloud_firestore/cloud_firestore.dart';

class MasterTaskModel {
  final String docId;
  final String title;
  final String desc;
  final DateTime createdAt;
  final String createdByDocId;
  final String createdByName;
  final DateTime updatedAt;
  final String updatedBy;
  final String updatedByName;
  final int duration; // in minutes/hours (decide in business logic)
  final String? place; // optional
  final List<Map<String, dynamic>> questions; // Or QuestionModel list
  final String departmentId;
  final String hotelId; // could be masterHotelId or normal hotelId
  final String assignedRole; // client, rm, gm, dm, staff
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String? serviceType; // optional
  final String frequency; // Daily, Weekly, Monthly, Yearly
  final String? dayOrDate; // specific day (Mon/Tue) or date (15th)
  final bool isActive;

  const MasterTaskModel({
    required this.docId,
    required this.title,
    required this.desc,
    required this.createdAt,
    required this.createdByDocId,
    required this.createdByName,
    required this.updatedAt,
    required this.updatedBy,
    required this.updatedByName,
    required this.duration,
    this.place,
    required this.questions,
    required this.departmentId,
    required this.hotelId,
    required this.assignedRole,
    this.startedAt,
    this.endedAt,
    this.serviceType,
    required this.frequency,
    this.dayOrDate,
    required this.isActive,
  });

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'title': title,
      'desc': desc,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'createdByDocId': createdByDocId,
      'createdByName': createdByName,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'updatedBy': updatedBy,
      'updatedByName': updatedByName,
      'duration': duration,
      'place': place,
      'questions': questions,
      'departmentId': departmentId,
      'hotelId': hotelId,
      'assignedRole': assignedRole,
      'startedAt': startedAt?.millisecondsSinceEpoch,
      'endedAt': endedAt?.millisecondsSinceEpoch,
      'serviceType': serviceType,
      'frequency': frequency,
      'dayOrDate': dayOrDate,
      'isActive': isActive,
    };
  }

  // Create from Firebase DocumentSnapshot
  factory MasterTaskModel.fromDocSnap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MasterTaskModel(
      docId: doc.id,
      title: data['title'] ?? '',
      desc: data['desc'] ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.parse(
              data['createdAt'] ?? DateTime.now().toIso8601String(),
            ),
      createdByDocId: data['createdByDocId'] ?? '',
      createdByName: data['createdByName'] ?? '',
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(
              data['updatedAt'] ?? DateTime.now().toIso8601String(),
            ),
      updatedBy: data['updatedBy'] ?? '',
      updatedByName: data['updatedByName'] ?? '',
      duration: data['duration'] ?? 30,
      place: data['place'],
      questions: List<Map<String, dynamic>>.from(data['questions'] ?? []),
      departmentId: data['departmentId'] ?? '',
      hotelId: data['hotelId'] ?? '',
      assignedRole: data['assignedRole'] ?? '',
      startedAt: data['startedAt'] != null
          ? (data['startedAt'] is Timestamp
                ? (data['startedAt'] as Timestamp).toDate()
                : DateTime.parse(data['startedAt']))
          : null,
      endedAt: data['endedAt'] != null
          ? (data['endedAt'] is Timestamp
                ? (data['endedAt'] as Timestamp).toDate()
                : DateTime.parse(data['endedAt']))
          : null,
      serviceType: data['serviceType'],
      frequency: data['frequency'] ?? 'Daily',
      dayOrDate: data['dayOrDate'],
      isActive: data['isActive'] ?? true,
    );
  }

  // Create from JSON (for API responses)
  factory MasterTaskModel.fromJson(Map<String, dynamic> json) {
    return MasterTaskModel(
      docId: json['docId'] ?? '',
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      createdByDocId: json['createdByDocId'] ?? '',
      createdByName: json['createdByName'] ?? '',
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedBy: json['updatedBy'] ?? '',
      updatedByName: json['updatedByName'] ?? '',
      duration: json['duration'] ?? 30,
      place: json['place'],
      questions: List<Map<String, dynamic>>.from(json['questions'] ?? []),
      departmentId: json['departmentId'] ?? '',
      hotelId: json['hotelId'] ?? '',
      assignedRole: json['assignedRole'] ?? '',
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'])
          : null,
      endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt']) : null,
      serviceType: json['serviceType'],
      frequency: json['frequency'] ?? 'Daily',
      dayOrDate: json['dayOrDate'],
      isActive: json['isActive'] ?? true,
    );
  }

  // Copy with method for creating modified copies
  MasterTaskModel copyWith({
    String? docId,
    String? title,
    String? desc,
    DateTime? createdAt,
    String? createdByDocId,
    String? createdByName,
    DateTime? updatedAt,
    String? updatedBy,
    String? updatedByName,
    int? duration,
    String? place,
    List<Map<String, dynamic>>? questions,
    String? departmentId,
    String? hotelId,
    String? assignedRole,
    DateTime? startedAt,
    DateTime? endedAt,
    String? serviceType,
    String? frequency,
    String? dayOrDate,
    bool? isActive,
  }) {
    return MasterTaskModel(
      docId: docId ?? this.docId,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      createdAt: createdAt ?? this.createdAt,
      createdByDocId: createdByDocId ?? this.createdByDocId,
      createdByName: createdByName ?? this.createdByName,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedByName: updatedByName ?? this.updatedByName,
      duration: duration ?? this.duration,
      place: place ?? this.place,
      questions: questions ?? this.questions,
      departmentId: departmentId ?? this.departmentId,
      hotelId: hotelId ?? this.hotelId,
      assignedRole: assignedRole ?? this.assignedRole,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      serviceType: serviceType ?? this.serviceType,
      frequency: frequency ?? this.frequency,
      dayOrDate: dayOrDate ?? this.dayOrDate,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'MasterTaskModel(docId: $docId, title: $title, assignedRole: $assignedRole, hotelId: $hotelId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MasterTaskModel && other.docId == docId;
  }

  @override
  int get hashCode => docId.hashCode;

  // Helper methods
  bool get hasPlace => place != null && place!.isNotEmpty;
  bool get hasServiceType => serviceType != null && serviceType!.isNotEmpty;
  bool get hasSchedule => dayOrDate != null && dayOrDate!.isNotEmpty;
  bool get hasQuestions => questions.isNotEmpty;
  bool get isStarted => startedAt != null;
  bool get isCompleted => endedAt != null;

  String get durationText {
    if (duration < 60) {
      return '${duration}min';
    } else {
      final hours = duration ~/ 60;
      final minutes = duration % 60;
      return minutes > 0 ? '${hours}h ${minutes}min' : '${hours}h';
    }
  }

  String get scheduleText {
    if (dayOrDate == null || dayOrDate!.isEmpty) {
      return frequency;
    }
    return '$frequency - $dayOrDate';
  }
}
