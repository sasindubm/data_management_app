import '../models/project.dart';
import '../database/database_helper.dart';

class ProjectRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertProject(Project project) async {
    return await _dbHelper.insert('Project', project.toMap());
  }

  Future<Project?> getProjectById(int projectId) async {
    final result = await _dbHelper.query(
      'Project',
      where: 'ProjectId = ?',
      whereArgs: [projectId],
    );
    if (result.isNotEmpty) {
      return Project.fromMap(result.first);
    }
    return null;
  }

  Future<List<Project>> getAllProjects() async {
    final result = await _dbHelper.query('Project');
    return result.map((map) => Project.fromMap(map)).toList();
  }

  Future<int> deleteProject(int projectId) async {
    return await _dbHelper.delete(
      'Project',
      where: 'ProjectId = ?',
      whereArgs: [projectId],
    );
  }

  Future<List<Project>> getProjectsByUserId(int userId) async {
    final result = await _dbHelper.query(
      'Project',
      where: 'UserId = ?',
      whereArgs: [userId],
    );
    return result.map((map) => Project.fromMap(map)).toList();
  }
  Future<List<Project>> getProjectsByMinistryId(int ministryId) async {
    final result = await _dbHelper.query(
      'Project',
      where: 'MinistryId = ?',
      whereArgs: [ministryId],
    );
    return result.map((map) => Project.fromMap(map)).toList();
  }
}
