class UserCreatesProject {
  final int ucpId;
  final int? userId;
  final int? projectId;

  UserCreatesProject({
    required this.ucpId,
    this.userId,
    this.projectId,
  });

  Map<String, dynamic> toMap() {
    return {
      'UCPId': ucpId,
      'UserId': userId,
      'ProjectId': projectId,
    };
  }

  factory UserCreatesProject.fromMap(Map<String, dynamic> map) {
    return UserCreatesProject(
      ucpId: map['UCPId'],
      userId: map['UserId'],
      projectId: map['ProjectId'],
    );
  }
}
