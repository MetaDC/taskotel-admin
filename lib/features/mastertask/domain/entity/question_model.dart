class QuestionModel {
  String questionId;
  String questionText;
  String questionType;
  List<String> options;
  bool isRequired;

  QuestionModel({
    required this.questionId,
    required this.questionText,
    required this.questionType,
    required this.options,
    required this.isRequired,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionId: json['questionId'] ?? '',
      questionText: json['questionText'] ?? '',
      questionType: json['questionType'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      isRequired: json['isRequired'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'questionType': questionType,
      'options': options,
      'isRequired': isRequired,
    };
  }
}
