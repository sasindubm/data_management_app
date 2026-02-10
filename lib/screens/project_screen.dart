import 'package:flutter/material.dart';
import '../controllers/project_controller.dart';
import '../models/project.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)!.settings.arguments as int;
    final controller = ProjectController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Screen'),
      ),
      body: FutureBuilder<List<Project>>(
        future: controller.fetchProjectsByUser(userId), // async call
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final projects = snapshot.data ?? [];
          if (projects.isEmpty) {
            return const Center(child: Text('No projects found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Card(
                child: ListTile(
                  title: Text(project.projectName),
                  subtitle: Text(project.projectDescription),
                  trailing: Text(project.projectStatus),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
