import '../models/ministry.dart';
import '../database/database_helper.dart';

class MinistryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertMinistry(Ministry ministry) async {
    return await _dbHelper.insert('Ministry', ministry.toMap());
  }

  Future<Ministry?> getMinistryById(int ministryId) async {
    final result = await _dbHelper.query(
      'Ministry',
      where: 'MinistryId = ?',
      whereArgs: [ministryId],
    );
    if (result.isNotEmpty) {
      return Ministry.fromMap(result.first);
    }
    return null;
  }

  Future<List<Ministry>> getAllMinistries() async {
    final result = await _dbHelper.query('Ministry');
    return result.map((map) => Ministry.fromMap(map)).toList();
  }

  Future<int> updateMinistry(Ministry ministry) async {
    return await _dbHelper.update(
      'Ministry',
      ministry.toMap(),
      where: 'MinistryId = ?',
      whereArgs: [ministry.ministryId],
    );
  }

  Future<int> deleteMinistry(int ministryId) async {
    return await _dbHelper.delete(
      'Ministry',
      where: 'MinistryId = ?',
      whereArgs: [ministryId],
    );
  }
}
