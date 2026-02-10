class Ministry {
  final int? ministryId;
  final String ministryName;

  Ministry({this.ministryId, required this.ministryName});

  Map<String, dynamic> toMap() {
    return {
      'MinistryId': ministryId,
      'MinistryName': ministryName,
    };
  }

  factory Ministry.fromMap(Map<String, dynamic> map) {
    return Ministry(
      ministryId: map['MinistryId'],
      ministryName: map['MinistryName'],
    );
  }
}
