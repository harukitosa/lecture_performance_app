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

  factory EvaluationType.fromMap(Map<String, dynamic> json) =>
      new EvaluationType(
        id: json["id"],
        title: json["title"],
        createTime: json["created_at"],
        updateTime: json["updated_at"],
      );

  Map<String, dynamic> toMapNew() {
    return {
      'id': id,
      'title': title,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}
