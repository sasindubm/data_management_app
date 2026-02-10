class ProjectAssignment {
  final int? projectAssignmentId;
  final int? projectId;
  final int? userId;

  ProjectAssignment({
    this.projectAssignmentId,
    this.projectId,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'ProjectAssignmentId': projectAssignmentId,
      'ProjectId': projectId,
      'UserId': userId,
    };
  }

  factory ProjectAssignment.fromMap(Map<String, dynamic> map) {
    return ProjectAssignment(
      projectAssignmentId: map['ProjectAssignmentId'],
      projectId: map['ProjectId'],
      userId: map['UserId'],
    );
  }
}
