class HomeRoom {
  final int id;
  final String grade;
  final String lectureClass;
  final String createTime;
  String updateTime;

  HomeRoom({
    this.id,
    this.grade,
    this.lectureClass,
    this.createTime,
    this.updateTime,
  });

  factory HomeRoom.fromMap(Map<String, dynamic> json) => new HomeRoom(
        id: json["id"],
        grade: json["grade"],
        lectureClass: json["lectureClass"],
        createTime: json["created_at"],
        updateTime: json["updated_at"],
      );

  Map<String, dynamic> toMapNew() {
    return {
      'id': id,
      'grade': grade,
      'lectureClass': lectureClass,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}
