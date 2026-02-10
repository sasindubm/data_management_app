import '../models/answer_choice.dart';
import '../database/database_helper.dart';

class AnswerChoiceRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertAnswerChoice(AnswerChoice answerChoice) async {
    return await _dbHelper.insert('AnswerChoice', answerChoice.toMap());
  }

  Future<AnswerChoice?> getAnswerChoiceByIds(int answerId, int choiceId) async {
    final result = await _dbHelper.query(
      'AnswerChoice',
      where: 'AnswerId = ? AND ChoiceId = ?',
      whereArgs: [answerId, choiceId],
    );
    if (result.isNotEmpty) {
      return AnswerChoice.fromMap(result.first);
    }
    return null;
  }

  Future<List<AnswerChoice>> getAllAnswerChoices() async {
    final result = await _dbHelper.query('AnswerChoice');
    return result.map((map) => AnswerChoice.fromMap(map)).toList();
  }

  Future<List<AnswerChoice>> getAnswerChoicesByAnswerId(int answerId) async {
    final result = await _dbHelper.query(
      'AnswerChoice',
      where: 'AnswerId = ?',
      whereArgs: [answerId],
    );
    return result.map((map) => AnswerChoice.fromMap(map)).toList();
  }

  Future<List<AnswerChoice>> getAnswerChoicesByChoiceId(int choiceId) async {
    final result = await _dbHelper.query(
      'AnswerChoice',
      where: 'ChoiceId = ?',
      whereArgs: [choiceId],
    );
    return result.map((map) => AnswerChoice.fromMap(map)).toList();
  }

  Future<int> deleteAnswerChoice(int answerId, int choiceId) async {
    return await _dbHelper.delete(
      'AnswerChoice',
      where: 'AnswerId = ? AND ChoiceId = ?',
      whereArgs: [answerId, choiceId],
    );
  }
}
