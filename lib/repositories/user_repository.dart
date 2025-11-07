import '../models/user.dart';
import '../database/database_helper.dart';

class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertUser(User user) async {
    return await _dbHelper.insert('User', user.toMap());
  }

  Future<User?> getUserByUsername(String username) async {
    final result = await _dbHelper.query(
      'User',
      where: 'Username = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<bool> usernameExists(String username) async {
    final user = await getUserByUsername(username);
    return user != null;
  }

  Future<int> deleteUser(int userId) async {
    return await _dbHelper.delete(
      'User',
      where: 'UserId = ?',
      whereArgs: [userId],
    );
  }

  Future<User?> getUserById(int userId) async {
    final result = await _dbHelper.query(
      'User',
      where: 'UserId = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    return await _dbHelper.update(
      'User',
      user.toMap(),
      where: 'UserId = ?',
      whereArgs: [user.userId],
    );
  }
  
}
