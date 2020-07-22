class HomeRoom {
  HomeRoom({
    this.id,
    this.grade,
    this.lectureClass,
    this.createTime,
    this.updateTime,
  });

  factory HomeRoom.fromMap(Map<String, dynamic> json) => HomeRoom(
        id: json['id'] as int,
        grade: json['grade'] as String,
        lectureClass: json['lectureClass'] as String,
        createTime: json['created_at'] as String,
        updateTime: json['updated_at'] as String,
      );

  final int id;
  final String grade;
  final String lectureClass;
  final String createTime;
  String updateTime;

  Map<String, dynamic> toMapNew() {
    // ignore: implicit_dynamic_map_literal
    return {
      'id': id,
      'grade': grade,
      'lectureClass': lectureClass,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}
