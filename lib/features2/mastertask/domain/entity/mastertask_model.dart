import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features2/mastertask/domain/entity/question_model.dart';

class MasterTaskModel {
  String docId;
  String title;
  String desc;
  DateTime createdAt;
  String createdBydocId;
  String createdByName;
  DateTime updatedAt;
  String updatedBy;
  String updatedByName;
  int duration;
  String place;
  List<QuestionModel> questions;
  String departmentId;
  String masterHotelId;
  String assignedRole;
  DateTime startedAt;
  DateTime endedAt;
  String serviceType;
  String frequency;
  String dayOrDate;
  bool isActive;

  MasterTaskModel({
    required this.docId,
    required this.title,
    required this.desc,
    required this.createdAt,
    required this.createdBydocId,
    required this.createdByName,
    required this.updatedAt,
    required this.updatedBy,
    required this.updatedByName,
    required this.duration,
    required this.place,
    required this.questions,
    required this.departmentId,
    required this.masterHotelId,
    required this.assignedRole,
    required this.startedAt,
    required this.endedAt,
    required this.serviceType,
    required this.frequency,
    required this.dayOrDate,
    required this.isActive,
  });

  factory MasterTaskModel.fromJson(Map<String, dynamic> json) {
    return MasterTaskModel(
      docId: json['docId'] ?? '',
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      createdBydocId: json['createdBydocId'] ?? '',
      createdByName: json['createdByName'] ?? '',
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      updatedBy: json['updatedBy'] ?? '',
      updatedByName: json['updatedByName'] ?? '',
      duration: (json['duration'] as num).toInt(),
      place: json['place'] ?? '',
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((q) => QuestionModel.fromJson(q))
              .toList() ??
          [],
      departmentId: json['departmentId'] ?? '',
      masterHotelId: json['masterHotelId'] ?? '',
      assignedRole: json['assignedRole'] ?? '',
      startedAt: (json['startedAt'] as Timestamp).toDate(),
      endedAt: (json['endedAt'] as Timestamp).toDate(),
      serviceType: json['serviceType'] ?? '',
      frequency: json['frequency'] ?? '',
      dayOrDate: json['dayOrDate'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  factory MasterTaskModel.fromDocSnap(DocumentSnapshot docSnap) {
    final data = docSnap.data() as Map<String, dynamic>;
    return MasterTaskModel.fromJson({...data, 'docId': docSnap.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'title': title,
      'desc': desc,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBydocId': createdBydocId,
      'createdByName': createdByName,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'updatedBy': updatedBy,
      'updatedByName': updatedByName,
      'duration': duration,
      'place': place,
      'questions': questions.map((q) => q.toJson()).toList(),
      'departmentId': departmentId,
      'masterHotelId': masterHotelId,
      'assignedRole': assignedRole,
      'startedAt': Timestamp.fromDate(startedAt),
      'endedAt': Timestamp.fromDate(endedAt),
      'serviceType': serviceType,
      'frequency': frequency,
      'dayOrDate': dayOrDate,
      'isActive': isActive,
    };
  }

  Map<String, dynamic> toMap() => toJson();
}
