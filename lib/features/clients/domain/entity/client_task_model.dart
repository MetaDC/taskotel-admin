import 'package:cloud_firestore/cloud_firestore.dart';

class ClientTaskModel {
  final String docId;
  final String title;
  final String desc;
  final DateTime createdAt;
  final String createdByDocId;
  final String createdByName;
  final DateTime updatedAt;
  final String updatedBy;
  final String updatedByName;
  final int duration; // in minutes
  final String? place;
  final List<Map<String, dynamic>> questions;
  final String departmentId;
  final String hotelId; // Client hotel ID
  final String clientId; // Client ID
  final String assignedRole; // rm, gm, dm, operators
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String? serviceType;
  final String frequency; // Daily, Weekly, Monthly, Yearly
  final String? dayOrDate;
  final bool isActive;
  final String status; // pending, in_progress, completed, overdue
  final String? completedBy;
  final DateTime? completedAt;
  final String? notes;
  final List<String>? attachments;
  final String masterTaskId; // Reference to master task template
  final int priority; // 1-5 (1 = highest)
  final DateTime? dueDate;
  final bool isRecurring;
  final Map<String, dynamic>? recurringConfig;

  ClientTaskModel({
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
    required this.clientId,
    required this.assignedRole,
    this.startedAt,
    this.endedAt,
    this.serviceType,
    required this.frequency,
    this.dayOrDate,
    required this.isActive,
    required this.status,
    this.completedBy,
    this.completedAt,
    this.notes,
    this.attachments,
    required this.masterTaskId,
    required this.priority,
    this.dueDate,
    required this.isRecurring,
    this.recurringConfig,
  });

  factory ClientTaskModel.fromJson(Map<String, dynamic> json, String docId) {
    return ClientTaskModel(
      docId: docId,
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      createdByDocId: json['createdByDocId'] ?? '',
      createdByName: json['createdByName'] ?? '',
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      updatedBy: json['updatedBy'] ?? '',
      updatedByName: json['updatedByName'] ?? '',
      duration: json['duration'] ?? 30,
      place: json['place'],
      questions: List<Map<String, dynamic>>.from(json['questions'] ?? []),
      departmentId: json['departmentId'] ?? '',
      hotelId: json['hotelId'] ?? '',
      clientId: json['clientId'] ?? '',
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
      status: json['status'] ?? 'pending',
      completedBy: json['completedBy'],
      completedAt: json['completedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['completedAt'])
          : null,
      notes: json['notes'],
      attachments: json['attachments'] != null 
          ? List<String>.from(json['attachments'])
          : null,
      masterTaskId: json['masterTaskId'] ?? '',
      priority: json['priority'] ?? 3,
      dueDate: json['dueDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['dueDate'])
          : null,
      isRecurring: json['isRecurring'] ?? false,
      recurringConfig: json['recurringConfig'],
    );
  }

  factory ClientTaskModel.fromDocSnap(QueryDocumentSnapshot<Map<String, dynamic>> snap) {
    return ClientTaskModel.fromJson(snap.data(), snap.id);
  }

  factory ClientTaskModel.fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data()!;
    return ClientTaskModel.fromJson(data, snap.id);
  }

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
      'clientId': clientId,
      'assignedRole': assignedRole,
      'startedAt': startedAt?.millisecondsSinceEpoch,
      'endedAt': endedAt?.millisecondsSinceEpoch,
      'serviceType': serviceType,
      'frequency': frequency,
      'dayOrDate': dayOrDate,
      'isActive': isActive,
      'status': status,
      'completedBy': completedBy,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'notes': notes,
      'attachments': attachments,
      'masterTaskId': masterTaskId,
      'priority': priority,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isRecurring': isRecurring,
      'recurringConfig': recurringConfig,
    };
  }

  ClientTaskModel copyWith({
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
    String? clientId,
    String? assignedRole,
    DateTime? startedAt,
    DateTime? endedAt,
    String? serviceType,
    String? frequency,
    String? dayOrDate,
    bool? isActive,
    String? status,
    String? completedBy,
    DateTime? completedAt,
    String? notes,
    List<String>? attachments,
    String? masterTaskId,
    int? priority,
    DateTime? dueDate,
    bool? isRecurring,
    Map<String, dynamic>? recurringConfig,
  }) {
    return ClientTaskModel(
      docId: docId,
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
      clientId: clientId ?? this.clientId,
      assignedRole: assignedRole ?? this.assignedRole,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      serviceType: serviceType ?? this.serviceType,
      frequency: frequency ?? this.frequency,
      dayOrDate: dayOrDate ?? this.dayOrDate,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      completedBy: completedBy ?? this.completedBy,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
      masterTaskId: masterTaskId ?? this.masterTaskId,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringConfig: recurringConfig ?? this.recurringConfig,
    );
  }
}
