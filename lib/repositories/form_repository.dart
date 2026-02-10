import '../models/form.dart';
import '../database/database_helper.dart';

class FormRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertForm(Form form) async {
    return await _dbHelper.insert('Form', form.toMap());
  }

  Future<Form?> getFormById(int formId) async {
    final result = await _dbHelper.query(
      'Form',
      where: 'FormId = ?',
      whereArgs: [formId],
    );
    if (result.isNotEmpty) {
      return Form.fromMap(result.first);
    }
    return null;
  }

  Future<List<Form>> getAllForms() async {
    final result = await _dbHelper.query('Form');
    return result.map((map) => Form.fromMap(map)).toList();
  }

  Future<List<Form>> getFormsByProjectId(int projectId) async {
    final result = await _dbHelper.query(
      'Form',
      where: 'ProjectId = ?',
      whereArgs: [projectId],
    );
    return result.map((map) => Form.fromMap(map)).toList();
  }

  Future<int> updateForm(Form form) async {
    return await _dbHelper.update(
      'Form',
      form.toMap(),
      where: 'FormId = ?',
      whereArgs: [form.formId],
    );
  }

  Future<int> deleteForm(int formId) async {
    return await _dbHelper.delete(
      'Form',
      where: 'FormId = ?',
      whereArgs: [formId],
    );
  }
}
