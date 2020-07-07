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

  Map<String, String> toMapNew() {
    return {
      'id': id as String,
      'student_id': studentID as String,
      'type_id': typeID as String,
      'point': point as String,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}
