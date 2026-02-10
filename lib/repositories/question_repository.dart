import '../models/question.dart';
import '../database/database_helper.dart';

class QuestionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertQuestion(Question question) async {
    return await _dbHelper.insert('Question', question.toMap());
  }

  Future<Question?> getQuestionById(int questionId) async {
    final result = await _dbHelper.query(
      'Question',
      where: 'QuestionId = ?',
      whereArgs: [questionId],
    );
    if (result.isNotEmpty) {
      return Question.fromMap(result.first);
    }
    return null;
  }

  Future<List<Question>> getAllQuestions() async {
    final result = await _dbHelper.query('Question');
    return result.map((map) => Question.fromMap(map)).toList();
  }

  Future<List<Question>> getQuestionsByFormId(int formId) async {
    final result = await _dbHelper.query(
      'Question',
      where: 'FormId = ?',
      whereArgs: [formId],
    );
    return result.map((map) => Question.fromMap(map)).toList();
  }

  Future<int> updateQuestion(Question question) async {
    return await _dbHelper.update(
      'Question',
      question.toMap(),
      where: 'QuestionId = ?',
      whereArgs: [question.questionId],
    );
  }

  Future<int> deleteQuestion(int questionId) async {
    return await _dbHelper.delete(
      'Question',
      where: 'QuestionId = ?',
      whereArgs: [questionId],
    );
  }
}
