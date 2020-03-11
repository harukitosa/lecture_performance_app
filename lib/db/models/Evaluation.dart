class Evaluation {

  final int id;
  final int studentID;
  final int typeID;
  final int semesterID;
  final int point;
  final String createTime;
  String updateTime;

  Evaluation({
    this.id,
    this.studentID,
    this.typeID,
    this.semesterID,
    this.point,
    this.createTime,
    this.updateTime,
  });

  factory Evaluation.fromMap(Map<String, dynamic> json) => new Evaluation(
      id: json["id"],
      studentID: json["student_id"],
      typeID: json["type_id"],
      semesterID: json["semester_id"],
      point: json["point"],
      createTime: json["create_at"],
      updateTime: json["update_at"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'student_id': studentID,
      'type_id': typeID,
      'semester_id': semesterID,
      'point': point,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}