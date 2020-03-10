class EvaluationType {

  final int id;
  final int evaluationID;
  final String title;
  final String createTime;
  String updateTime;
  String deleteTime;

  EvaluationType({
    this.id,
    this.evaluationID,
    this.title,
    this.createTime,
    this.updateTime,
    this.deleteTime,
  });

  factory EvaluationType.fromMap(Map<String, dynamic> json) => new EvaluationType(
      id: json["id"],
      evaluationID: json["evaluationID"],
      title: json["title"],
      createTime: json["createTime"],
      updateTime: json["updateTime"],
      deleteTime: json["deleteTime"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'evaluationID': evaluationID,
      'title': title,
      'createTime': createTime,
      'updateTime': updateTime,
      'delteTime': deleteTime,
    };
  }
  
}