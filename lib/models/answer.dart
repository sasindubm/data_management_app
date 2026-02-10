class Answer {
  final int? answerId;
  final String? answerText;
  final int? questionId;
  final int? responseId;

  Answer({
    this.answerId,
    this.answerText,
    this.questionId,
    this.responseId,
  });

  Map<String, dynamic> toMap() {
    return {
      'AnswerId': answerId,
      'AnswerText': answerText,
      'QuestionId': questionId,
      'ResponseId': responseId,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      answerId: map['AnswerId'],
      answerText: map['AnswerText'],
      questionId: map['QuestionId'],
      responseId: map['ResponseId'],
    );
  }
}
