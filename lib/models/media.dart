class Media {
  final int? mediaId;
  final String? mediaName;
  final String? mediaType;
  final String? extension;
  final String? location;
  final int? answerId;

  Media({
    this.mediaId,
    this.mediaName,
    this.mediaType,
    this.extension,
    this.location,
    this.answerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'MediaId': mediaId,
      'MediaName': mediaName,
      'MediaType': mediaType,
      'Extension': extension,
      'Location': location,
      'AnswerId': answerId,
    };
  }

  factory Media.fromMap(Map<String, dynamic> map) {
    return Media(
      mediaId: map['MediaId'],
      mediaName: map['MediaName'],
      mediaType: map['MediaType'],
      extension: map['Extension'],
      location: map['Location'],
      answerId: map['AnswerId'],
    );
  }
}
