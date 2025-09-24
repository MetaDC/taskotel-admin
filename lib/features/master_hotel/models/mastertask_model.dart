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

  MasterTaskModel({
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
    this.isActive = true,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
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

  /// From JSON
  factory MasterTaskModel.fromJson(Map<String, dynamic> json, String docId) {
    return MasterTaskModel(
      docId: docId,
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      createdByDocId: json['createdByDocId'] ?? '',
      createdByName: json['createdByName'] ?? '',
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      updatedBy: json['updatedBy'] ?? '',
      updatedByName: json['updatedByName'] ?? '',
      duration: json['duration'] ?? 0,
      place: json['place'],
      questions: List<Map<String, dynamic>>.from(json['questions'] ?? []),
      departmentId: json['departmentId'] ?? '',
      hotelId: json['hotelId'] ?? '',
      assignedRole: json['assignedRole'] ?? '',
      startedAt: json['startedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['startedAt'])
          : null,
      endedAt: json['endedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['endedAt'])
          : null,
      serviceType: json['serviceType'],
      frequency: json['frequency'] ?? 'Daily',
      dayOrDate: json['dayOrDate'],
      isActive: json['isActive'] ?? true,
    );
  }

  /// From QueryDocumentSnapshot
  factory MasterTaskModel.fromSnap(
    QueryDocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data();
    return MasterTaskModel.fromJson(data, snap.id);
  }

  /// From DocumentSnapshot
  factory MasterTaskModel.fromDocSnap(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data()!;
    return MasterTaskModel.fromJson(data, snap.id);
  }

  /// CopyWith
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
}



/* 
/// Represents a schedulable task on the 24-hour timeline.
class TaskModel {
  final String id;
  final String title;
  final String staffId; // assignee (user doc id)
  final String? hotelId;
  final DateTime startAt;
  final DateTime endAt;
  final String priority; // low, medium, high
  final String? notes;
  final String? color; // hex color for UI
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.staffId,
    this.hotelId,
    required this.startAt,
    required this.endAt,
    required this.priority,
    this.notes,
    this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  Duration get duration => endAt.difference(startAt);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'staffId': staffId,
      'hotelId': hotelId,
      'startAt': Timestamp.fromDate(startAt),
      'endAt': Timestamp.fromDate(endAt),
      'priority': priority,
      'notes': notes,
      'color': color,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory TaskModel.fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data()!;
    return TaskModel(
      id: snap.id,
      title: data['title'] ?? '',
      staffId: data['staffId'] ?? '',
      hotelId: data['hotelId'],
      startAt: (data['startAt'] as Timestamp).toDate(),
      endAt: (data['endAt'] as Timestamp).toDate(),
      priority: data['priority'] ?? 'low',
      notes: data['notes'],
      color: data['color'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory TaskModel.fromDocSnap(
    QueryDocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data();
    return TaskModel(
      id: snap.id,
      title: data['title'] ?? '',
      staffId: data['staffId'] ?? '',
      hotelId: data['hotelId'],
      startAt: (data['startAt'] as Timestamp).toDate(),
      endAt: (data['endAt'] as Timestamp).toDate(),
      priority: data['priority'] ?? 'low',
      notes: data['notes'],
      color: data['color'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  TaskModel copyWith({
    String? title,
    String? staffId,
    String? hotelId,
    DateTime? startAt,
    DateTime? endAt,
    String? priority,
    String? notes,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      staffId: staffId ?? this.staffId,
      hotelId: hotelId ?? this.hotelId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
 */