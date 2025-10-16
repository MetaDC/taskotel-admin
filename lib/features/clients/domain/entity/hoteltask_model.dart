import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features/clients/domain/entity/question_model.dart';

class CommonTaskModel {
  final String docId;
  final String taskId;
  final String title;
  final String desc;
  final DateTime createdAt;
  final String createdByDocId;
  final String createdByName;
  final DateTime updatedAt;
  final String updatedBy;
  final String updatedByName;

  final String hotelId;
  final String assignedRole;
  final String? assignedDepartmentId;
  final String? serviceType;
  final String frequency; // Daily, Weekly, Monthly, Yearly
  final String dayOrDate;
  final String duration;
  final String place;
  final List<QuestionModel> questions; // or List<QuestionModel>
  final DateTime? startDate; // null for master hotel
  final DateTime? endDate; // null if not to end this
  final bool? fromMasterHotel;

  final bool isActive;

  CommonTaskModel({
    required this.docId,
    required this.taskId,
    required this.title,
    required this.desc,
    required this.createdAt,
    required this.createdByDocId,
    required this.createdByName,
    required this.updatedAt,
    required this.updatedBy,
    required this.updatedByName,
    required this.hotelId,
    required this.assignedRole,
    this.assignedDepartmentId,
    this.serviceType,
    required this.frequency,
    required this.dayOrDate,
    required this.duration,
    required this.place,
    required this.questions,
    this.startDate,
    this.endDate,
    this.fromMasterHotel,
    required this.isActive,
  });

  /// From Firestore snapshot
  factory CommonTaskModel.fromSnap(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return CommonTaskModel.fromJson({...data, "docId": snap.id});
  }

  /// From JSON / Map
  factory CommonTaskModel.fromJson(Map<String, dynamic> json) {
    return CommonTaskModel(
      docId: json["docId"] ?? "",
      taskId: json["taskId"] ?? "",
      title: json["title"] ?? "",
      desc: json["desc"] ?? "",
      createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"] ?? 0),
      createdByDocId: json["createdByDocId"] ?? "",
      createdByName: json["createdByName"] ?? "",
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json["updatedAt"] ?? 0),
      updatedBy: json["updatedBy"] ?? "",
      updatedByName: json["updatedByName"] ?? "",
      hotelId: json["hotelId"],
      assignedRole: json["assignedRole"] ?? "",
      assignedDepartmentId: json["assignedDepartmentId"],
      serviceType: json["serviceType"],
      frequency: json["frequency"] ?? "Daily",
      dayOrDate: json["dayOrDate"] ?? "",
      duration: json["duration"] ?? "",
      place: json["place"] ?? "",
      questions: List<QuestionModel>.from(json["questions"] ?? []),
      startDate: json["startDate"] != null
          ? DateTime.fromMillisecondsSinceEpoch(json["startDate"])
          : null,
      endDate: json["endDate"] != null
          ? DateTime.fromMillisecondsSinceEpoch(json["endDate"])
          : null,
      fromMasterHotel: json["fromMasterHotel"],
      isActive: json["isActive"] ?? true,
    );
  }

  /// To Map / JSON for Firestore
  Map<String, dynamic> toMap() {
    return {
      "taskId": taskId,
      "title": title,
      "desc": desc,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "createdByDocId": createdByDocId,
      "createdByName": createdByName,
      "updatedAt": updatedAt.millisecondsSinceEpoch,
      "updatedBy": updatedBy,
      "updatedByName": updatedByName,
      "hotelId": hotelId,
      "assignedRole": assignedRole,
      "assignedDepartmentId": assignedDepartmentId,
      "serviceType": serviceType,
      "frequency": frequency,
      "dayOrDate": dayOrDate,
      "duration": duration,
      "place": place,
      "questions": questions.map((e) => e.toMap()).toList(),
      "startDate": startDate?.millisecondsSinceEpoch,
      "endDate": endDate?.millisecondsSinceEpoch,
      "fromMasterHotel": fromMasterHotel,
      "isActive": isActive,
    };
  }

  CommonTaskModel copyWith({
    String? title,
    String? desc,
    String? frequency,
    String? dayOrDate,
    String? duration,
    String? place,
    List<QuestionModel>? questions,
    DateTime? startDate,
    DateTime? endDate,
    bool? fromMasterHotel,
    bool? isActive,
  }) {
    return CommonTaskModel(
      docId: docId,
      taskId: taskId,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      frequency: frequency ?? this.frequency,
      dayOrDate: dayOrDate ?? this.dayOrDate,
      duration: duration ?? this.duration,
      place: place ?? this.place,
      questions: questions ?? this.questions,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      fromMasterHotel: fromMasterHotel ?? this.fromMasterHotel,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      createdByDocId: createdByDocId,
      createdByName: createdByName,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      updatedByName: updatedByName,
      hotelId: hotelId,
      assignedRole: assignedRole,
      assignedDepartmentId: assignedDepartmentId,
      serviceType: serviceType,
    );
  }
}
