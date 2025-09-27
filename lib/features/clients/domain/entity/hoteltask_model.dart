import 'package:cloud_firestore/cloud_firestore.dart';

class CommonTaskModel {
  final String docId;
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
  final List<Map<String, dynamic>> questions; // or List<QuestionModel>
  final DateTime? startDate; // null for master hotel
  final DateTime? endDate; // null if not to end this
  final bool fromMasterHotel;
  final bool isActive;

  CommonTaskModel({
    required this.docId,
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
    required this.fromMasterHotel,
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
      questions: List<Map<String, dynamic>>.from(json["questions"] ?? []),
      startDate: json["startDate"] != null
          ? DateTime.fromMillisecondsSinceEpoch(json["startDate"])
          : null,
      endDate: json["endDate"] != null
          ? DateTime.fromMillisecondsSinceEpoch(json["endDate"])
          : null,
      fromMasterHotel: json["fromMasterHotel"] ?? false,
      isActive: json["isActive"] ?? true,
    );
  }

  /// To Map / JSON for Firestore
  Map<String, dynamic> toMap() {
    return {
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
      "questions": questions,
      "startDate": startDate?.millisecondsSinceEpoch,
      "endDate": endDate?.millisecondsSinceEpoch,
      "fromMasterHotel": fromMasterHotel,
      "isActive": isActive,
    };
  }
}
