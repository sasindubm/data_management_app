class Project {
  final int? projectId;
  final String projectName;
  final String projectLocation;
  final String projectDescription;
  final String projectStatus;
  final int ministryId;
  final String fundSource;
  final int userId;
  final DateTime startedDate;
  final DateTime? finishedDate;

  Project({
    this.projectId,
    required this.projectName,
    required this.projectLocation,
    required this.projectDescription,
    required this.projectStatus,
    required this.ministryId,
    required this.fundSource,
    required this.userId,
    required this.startedDate,
    this.finishedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'ProjectId': projectId,
      'ProjectName': projectName,
      'ProjectLocation': projectLocation,
      'ProjectDescription': projectDescription,
      'ProjectStatus': projectStatus,
      'MinistryId': ministryId,
      'FundSource': fundSource,
      'UserId': userId,
      'StartedDate': startedDate.toIso8601String(),
      'FinishedDate': finishedDate?.toIso8601String(),
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      projectId: map['ProjectId'],
      projectName: map['ProjectName'],
      projectLocation: map['ProjectLocation'],
      projectDescription: map['ProjectDescription'],
      projectStatus: map['ProjectStatus'],
      ministryId: map['MinistryId'],
      fundSource: map['FundSource'],
      userId: map['UserId'],
      startedDate: DateTime.parse(map['StartedDate']),
      finishedDate: map['FinishedDate'] != null
          ? DateTime.parse(map['FinishedDate'])
          : null,
    );
  }
}
