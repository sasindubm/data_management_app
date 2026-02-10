import '../models/project_assignment.dart';
import '../database/database_helper.dart';

class ProjectAssignmentRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertProjectAssignment(
      ProjectAssignment projectAssignment) async {
    return await _dbHelper.insert(
        'ProjectAssignment', projectAssignment.toMap());
  }

  Future<ProjectAssignment?> getProjectAssignmentById(
      int projectAssignmentId) async {
    final result = await _dbHelper.query(
      'ProjectAssignment',
      where: 'ProjectAssignmentId = ?',
      whereArgs: [projectAssignmentId],
    );
    if (result.isNotEmpty) {
      return ProjectAssignment.fromMap(result.first);
    }
    return null;
  }

  Future<List<ProjectAssignment>> getAllProjectAssignments() async {
    final result = await _dbHelper.query('ProjectAssignment');
    return result.map((map) => ProjectAssignment.fromMap(map)).toList();
  }

  Future<List<ProjectAssignment>> getAssignmentsByProjectId(
      int projectId) async {
    final result = await _dbHelper.query(
      'ProjectAssignment',
      where: 'ProjectId = ?',
      whereArgs: [projectId],
    );
    return result.map((map) => ProjectAssignment.fromMap(map)).toList();
  }

  Future<List<ProjectAssignment>> getAssignmentsByUserId(int userId) async {
    final result = await _dbHelper.query(
      'ProjectAssignment',
      where: 'UserId = ?',
      whereArgs: [userId],
    );
    return result.map((map) => ProjectAssignment.fromMap(map)).toList();
  }

  Future<int> updateProjectAssignment(
      ProjectAssignment projectAssignment) async {
    return await _dbHelper.update(
      'ProjectAssignment',
      projectAssignment.toMap(),
      where: 'ProjectAssignmentId = ?',
      whereArgs: [projectAssignment.projectAssignmentId],
    );
  }

  Future<int> deleteProjectAssignment(int projectAssignmentId) async {
    return await _dbHelper.delete(
      'ProjectAssignment',
      where: 'ProjectAssignmentId = ?',
      whereArgs: [projectAssignmentId],
    );
  }
}
