class QuestionModel {
  final String questionId;
  final String question;
  final String type; // "slider", "yes_no", "textbox"
  final List<String>? options; // for multiple choice or slider labels
  final dynamic answer; // can be String, bool, int, etc.

  QuestionModel({
    required this.questionId,
    required this.question,
    required this.type,
    this.options,
    this.answer,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      questionId: map['questionId'] ?? '',
      question: map['question'] ?? '',
      type: map['type'] ?? '',
      options: map['options'] != null
          ? List<String>.from(map['options'])
          : null,
      answer: map['answer'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'question': question,
      'type': type,
      if (options != null) 'options': options,
      if (answer != null) 'answer': answer,
    };
  }
}
