class Evaluation {
  Evaluation({
    this.id,
    this.studentID,
    this.typeID,
    this.point,
    this.createTime,
    this.updateTime,
  });

  factory Evaluation.fromMap(Map<String, dynamic> json) => Evaluation(
        id: json['id'] as int,
        studentID: json['student_id'] as int,
        typeID: json['type_id'] as int,
        point: json['point'] as int,
        createTime: json['created_at'] as String,
        updateTime: json['updated_at'] as String,
      );

  final int id;
  final int studentID;
  final int typeID;
  final int point;
  final String createTime;
  String updateTime;
  String title;

  Map<String, dynamic> toMapNew() {
    return {
      'id': id,
      'student_id': studentID,
      'type_id': typeID,
      'point': point,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}
