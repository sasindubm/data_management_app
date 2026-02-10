import '../models/answer.dart';
import '../database/database_helper.dart';

class AnswerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertAnswer(Answer answer) async {
    return await _dbHelper.insert('Answer', answer.toMap());
  }

  Future<Answer?> getAnswerById(int answerId) async {
    final result = await _dbHelper.query(
      'Answer',
      where: 'AnswerId = ?',
      whereArgs: [answerId],
    );
    if (result.isNotEmpty) {
      return Answer.fromMap(result.first);
    }
    return null;
  }

  Future<List<Answer>> getAllAnswers() async {
    final result = await _dbHelper.query('Answer');
    return result.map((map) => Answer.fromMap(map)).toList();
  }

  Future<List<Answer>> getAnswersByQuestionId(int questionId) async {
    final result = await _dbHelper.query(
      'Answer',
      where: 'QuestionId = ?',
      whereArgs: [questionId],
    );
    return result.map((map) => Answer.fromMap(map)).toList();
  }

  Future<List<Answer>> getAnswersByResponseId(int responseId) async {
    final result = await _dbHelper.query(
      'Answer',
      where: 'ResponseId = ?',
      whereArgs: [responseId],
    );
    return result.map((map) => Answer.fromMap(map)).toList();
  }

  Future<int> updateAnswer(Answer answer) async {
    return await _dbHelper.update(
      'Answer',
      answer.toMap(),
      where: 'AnswerId = ?',
      whereArgs: [answer.answerId],
    );
  }

  Future<int> deleteAnswer(int answerId) async {
    return await _dbHelper.delete(
      'Answer',
      where: 'AnswerId = ?',
      whereArgs: [answerId],
    );
  }
}
