class Choice {
  final int? choiceId;
  final String? choiceText;
  final int? questionId;

  Choice({
    this.choiceId,
    this.choiceText,
    this.questionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'ChoiceId': choiceId,
      'ChoiceText': choiceText,
      'QuestionId': questionId,
    };
  }

  factory Choice.fromMap(Map<String, dynamic> map) {
    return Choice(
      choiceId: map['ChoiceId'],
      choiceText: map['ChoiceText'],
      questionId: map['QuestionId'],
    );
  }
}
