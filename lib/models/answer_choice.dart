class AnswerChoice {
  final int answerId;
  final int choiceId;

  AnswerChoice({
    required this.answerId,
    required this.choiceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'AnswerId': answerId,
      'ChoiceId': choiceId,
    };
  }

  factory AnswerChoice.fromMap(Map<String, dynamic> map) {
    return AnswerChoice(
      answerId: map['AnswerId'],
      choiceId: map['ChoiceId'],
    );
  }
}
