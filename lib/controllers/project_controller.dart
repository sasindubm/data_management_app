import '../repositories/project_repository.dart';
import '../models/project.dart';

class ProjectController {
  final ProjectRepository _projectRepo = ProjectRepository();

  Future<int> createProject(Project project) async {
    return await _projectRepo.insertProject(project);
  }
}