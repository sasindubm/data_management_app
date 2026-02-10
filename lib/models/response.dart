class Response {
  final int? responseId;
  final int? formId;
  final int? userId;
  final String? responseStatus;

  Response({
    this.responseId,
    this.formId,
    this.userId,
    this.responseStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'ResponseId': responseId,
      'FormId': formId,
      'UserId': userId,
      'ResponseStatus': responseStatus,
    };
  }

  factory Response.fromMap(Map<String, dynamic> map) {
    return Response(
      responseId: map['ResponseId'],
      formId: map['FormId'],
      userId: map['UserId'],
      responseStatus: map['ResponseStatus'],
    );
  }
}
