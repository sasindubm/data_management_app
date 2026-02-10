class Form {
  final int? formId;
  final int projectId;

  Form({
    this.formId,
    required this.projectId,
  });

  Map<String,dynamic> toMap(){
    return {
      'FormId': formId,
      'ProjectId': projectId,
    };
  }
  factory Form.fromMap(Map<String,dynamic> map){
    return Form(
      formId: map['FormId'],
      projectId: map['ProjectId'],
    );
  }
}
