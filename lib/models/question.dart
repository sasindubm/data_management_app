class Question {
  final int? questionId;
  final String questionText;
  final String? questionType;
  final int formId;

  Question({
    this.questionId,
    required this.questionText,
    this.questionType,
    required this.formId,
  });

  Map<String, dynamic> toMap() {
    return {
      'QuestionId': questionId,
      'QuestionText': questionText,
      'QuestionType': questionType,
      'FormId': formId,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionId: map['QuestionId'],
      questionText: map['QuestionText'],
      questionType: map['QuestionType'],
      formId: map['FormId'],
    );
  }
}
