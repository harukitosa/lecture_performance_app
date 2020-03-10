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
      studentID: json["studentID"],
      typeID: json["typeID"],
      semesterID: json["semesterID"],
      point: json["point"],
      createTime: json["create_at"],
      updateTime: json["update_at"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'studentID': studentID,
      'typeID': typeID,
      'semesterID': semesterID,
      'point': point,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}