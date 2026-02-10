import '../models/user_creates_project.dart';
import '../database/database_helper.dart';

class UserCreatesProjectRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertUserCreatesProject(
      UserCreatesProject userCreatesProject) async {
    return await _dbHelper.insert(
        'UserCreatesProject', userCreatesProject.toMap());
  }

  Future<UserCreatesProject?> getUserCreatesProjectById(int ucpId) async {
    final result = await _dbHelper.query(
      'UserCreatesProject',
      where: 'UCPId = ?',
      whereArgs: [ucpId],
    );
    if (result.isNotEmpty) {
      return UserCreatesProject.fromMap(result.first);
    }
    return null;
  }

  Future<List<UserCreatesProject>> getAllUserCreatesProjects() async {
    final result = await _dbHelper.query('UserCreatesProject');
    return result.map((map) => UserCreatesProject.fromMap(map)).toList();
  }

  Future<List<UserCreatesProject>> getProjectsByUserId(int userId) async {
    final result = await _dbHelper.query(
      'UserCreatesProject',
      where: 'UserId = ?',
      whereArgs: [userId],
    );
    return result.map((map) => UserCreatesProject.fromMap(map)).toList();
  }

  Future<List<UserCreatesProject>> getUsersByProjectId(int projectId) async {
    final result = await _dbHelper.query(
      'UserCreatesProject',
      where: 'ProjectId = ?',
      whereArgs: [projectId],
    );
    return result.map((map) => UserCreatesProject.fromMap(map)).toList();
  }

  Future<int> updateUserCreatesProject(
      UserCreatesProject userCreatesProject) async {
    return await _dbHelper.update(
      'UserCreatesProject',
      userCreatesProject.toMap(),
      where: 'UCPId = ?',
      whereArgs: [userCreatesProject.ucpId],
    );
  }

  Future<int> deleteUserCreatesProject(int ucpId) async {
    return await _dbHelper.delete(
      'UserCreatesProject',
      where: 'UCPId = ?',
      whereArgs: [ucpId],
    );
  }
}
