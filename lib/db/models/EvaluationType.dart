// ignore: file_names
class EvaluationType {
  EvaluationType({
    this.id,
    this.title,
    this.createTime,
    this.updateTime,
  });

  factory EvaluationType.fromMap(Map<String, dynamic> json) => EvaluationType(
        id: json['id'] as int,
        title: json['title'] as String,
        createTime: json['created_at'] as String,
        updateTime: json['updated_at'] as String,
      );

  final int id;
  final String title;
  final String createTime;
  String updateTime;

  Map<String, dynamic> toMapNew() {
    // ignore: implicit_dynamic_map_literal
    return {
      'id': id,
      'title': title,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}
