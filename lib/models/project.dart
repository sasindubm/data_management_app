class Project {
  final int projectId;
  final String projectName;
  final String projectTitle;
  final String projectDescription;
  final String projectStatus;
  final int departmentId;
  final int sectorId;
  final int userId;
  final DateTime startedDate;
  final DateTime? finishedDate;

  Project({
    required this.projectId,
    required this.projectName,
    required this.projectTitle,
    required this.projectDescription,
    required this.projectStatus,
    required this.departmentId,
    required this.sectorId,
    required this.userId,
    required this.startedDate,
    this.finishedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'ProjectId': projectId,
      'ProjectName' : projectName,
      'ProjectTitle' : projectTitle,
      'ProjectDescription' : projectDescription,
      'ProjectStatus' : projectStatus,
      'DepartmentId' : departmentId,
      'SectorId' : sectorId,
      'UserId' : userId,
      'StartedDate' : startedDate,
      'FinishedDate' : finishedDate,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      projectId: map['ProjectId'],
      projectName: map['ProjectName'],
      projectTitle: map['ProjectTitle'],
      projectDescription: map['ProjectDescription'],
      projectStatus: map['ProjectStatus'],
      departmentId: map['DepartmentId'],
      sectorId: map['SectorId'],
      userId: map['UserId'],
      startedDate: DateTime.parse(map['StartedDate']),
      finishedDate: map['FinishedDate'] != null ? DateTime.parse(map['FinishedDate']) : null,
    );
  }
}
