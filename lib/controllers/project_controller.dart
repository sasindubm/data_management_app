import '../models/project.dart';
import '../repositories/project_repository.dart';

class ProjectController {
  final ProjectRepository _repository = ProjectRepository();

  Future<void> createProject(Project project) async {
    await _repository.insertProject(project);
  }

  Future<Project?> fetchProject(int id) async {
    return await _repository.getProjectById(id);
  }

  Future<List<Project>> fetchAllProjects() async {
    return await _repository.getAllProjects();
  }

  Future<List<Project>> fetchProjectsByUser(int userId) async {
    return await _repository.getProjectsByUserId(userId);
  }

  Future<void> removeProject(int id) async {
    await _repository.deleteProject(id);
  }
  Future<List<Project>> getProjectsByMinistry(int ministryId) async {
    return await _repository.getProjectsByMinistryId(ministryId);
  }
}
