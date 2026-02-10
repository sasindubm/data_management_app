import '../models/choice.dart';
import '../database/database_helper.dart';

class ChoiceRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertChoice(Choice choice) async {
    return await _dbHelper.insert('Choice', choice.toMap());
  }

  Future<Choice?> getChoiceById(int choiceId) async {
    final result = await _dbHelper.query(
      'Choice',
      where: 'ChoiceId = ?',
      whereArgs: [choiceId],
    );
    if (result.isNotEmpty) {
      return Choice.fromMap(result.first);
    }
    return null;
  }

  Future<List<Choice>> getAllChoices() async {
    final result = await _dbHelper.query('Choice');
    return result.map((map) => Choice.fromMap(map)).toList();
  }

  Future<List<Choice>> getChoicesByQuestionId(int questionId) async {
    final result = await _dbHelper.query(
      'Choice',
      where: 'QuestionId = ?',
      whereArgs: [questionId],
    );
    return result.map((map) => Choice.fromMap(map)).toList();
  }

  Future<int> updateChoice(Choice choice) async {
    return await _dbHelper.update(
      'Choice',
      choice.toMap(),
      where: 'ChoiceId = ?',
      whereArgs: [choice.choiceId],
    );
  }

  Future<int> deleteChoice(int choiceId) async {
    return await _dbHelper.delete(
      'Choice',
      where: 'ChoiceId = ?',
      whereArgs: [choiceId],
    );
  }
}
