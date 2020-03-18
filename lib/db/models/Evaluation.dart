class Evaluation {

  final int id;
  final int studentID;
  final int typeID;
  final int point;
  final String createTime;
  String updateTime;
  String title;
  Evaluation({
    this.id,
    this.studentID,
    this.typeID,
    this.point,
    this.createTime,
    this.updateTime,
  });

  factory Evaluation.fromMap(Map<String, dynamic> json) => new Evaluation(
      id: json["id"],
      studentID: json["student_id"],
      typeID: json["type_id"],
      point: json["point"],
      createTime: json["created_at"],
      updateTime: json["updated_at"],
  );

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