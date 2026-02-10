class User {
  final int? userId;
  final String username;
  final String password;
  final int? ministryId;
  final int? sectorId;

  User({
    this.userId,
    required this.username,
    required this.password,
    this.ministryId,
    this.sectorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserId': userId,
      'Username': username,
      'Password': password,
      'MinistryId': ministryId,
      'SectorId': sectorId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['UserId'],
      username: map['Username'],
      password: map['Password'],
      ministryId: map['MinistryId'],
      sectorId: map['SectorId'],
    );
  }
}
