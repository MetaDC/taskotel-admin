import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentModel {
  final String docId;
  final String name;
  final DateTime createdAt;
  final String hotelId; // Can be master as well as client hotel
  final DateTime updatedAt;

  DepartmentModel({
    required this.docId,
    required this.name,
    required this.createdAt,
    required this.hotelId,
    required this.updatedAt,
  });

  /// 🔹 Convert to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "hotelId": hotelId,
      "updatedAt": updatedAt.millisecondsSinceEpoch,
    };
  }

  /// 🔹 From QueryDocumentSnapshot (for list fetch)
  factory DepartmentModel.fromSnap(
    QueryDocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data();
    return DepartmentModel(
      docId: snap.id,
      name: data['name'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      hotelId: data['hotelId'],
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updatedAt']),
    );
  }

  /// 🔹 From DocumentSnapshot (single doc fetch)
  factory DepartmentModel.fromDocSnap(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data()!;
    return DepartmentModel(
      docId: snap.id,
      name: data['name'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      hotelId: data['hotelId'],
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updatedAt']),
    );
  }

  /// 🔹 CopyWith method for easy updates
  DepartmentModel copyWith({
    String? name,
    DateTime? createdAt,
    String? hotelId,
    DateTime? updatedAt,
  }) {
    return DepartmentModel(
      docId: docId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      hotelId: hotelId ?? this.hotelId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
