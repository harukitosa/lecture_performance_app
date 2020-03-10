class EvaluationType {

  final int id;
  final String title;
  final String createTime;
  String updateTime;

  EvaluationType({
    this.id,
    this.title,
    this.createTime,
    this.updateTime,
  });

  factory EvaluationType.fromMap(Map<String, dynamic> json) => new EvaluationType(
      id: json["id"],
      title: json["title"],
      createTime: json["createTime"],
      updateTime: json["updateTime"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'title': title,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }
  
}