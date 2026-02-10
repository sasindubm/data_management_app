import '../models/response.dart';
import '../database/database_helper.dart';

class ResponseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertResponse(Response response) async {
    return await _dbHelper.insert('Response', response.toMap());
  }

  Future<Response?> getResponseById(int responseId) async {
    final result = await _dbHelper.query(
      'Response',
      where: 'ResponseId = ?',
      whereArgs: [responseId],
    );
    if (result.isNotEmpty) {
      return Response.fromMap(result.first);
    }
    return null;
  }

  Future<List<Response>> getAllResponses() async {
    final result = await _dbHelper.query('Response');
    return result.map((map) => Response.fromMap(map)).toList();
  }

  Future<List<Response>> getResponsesByFormId(int formId) async {
    final result = await _dbHelper.query(
      'Response',
      where: 'FormId = ?',
      whereArgs: [formId],
    );
    return result.map((map) => Response.fromMap(map)).toList();
  }

  Future<List<Response>> getResponsesByUserId(int userId) async {
    final result = await _dbHelper.query(
      'Response',
      where: 'UserId = ?',
      whereArgs: [userId],
    );
    return result.map((map) => Response.fromMap(map)).toList();
  }

  Future<int> updateResponse(Response response) async {
    return await _dbHelper.update(
      'Response',
      response.toMap(),
      where: 'ResponseId = ?',
      whereArgs: [response.responseId],
    );
  }

  Future<int> deleteResponse(int responseId) async {
    return await _dbHelper.delete(
      'Response',
      where: 'ResponseId = ?',
      whereArgs: [responseId],
    );
  }
}
