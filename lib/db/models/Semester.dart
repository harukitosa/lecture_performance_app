class Semester {
  Semester({
    this.id,
    this.homeRoomID,
    this.title,
    this.createTime,
    this.updateTime,
  });
  factory Semester.fromMap(Map<String, dynamic> json) => Semester(
        id: json['id'] as int,
        title: json['title'] as String,
        homeRoomID: json['homeroom_id'] as int,
        createTime: json['created_at'] as String,
        updateTime: json['updated_at'] as String,
      );

  final int id;
  final int homeRoomID;
  final String title;
  final String createTime;
  String updateTime;

  Map<String, dynamic> toMapNew() {
    // ignore: implicit_dynamic_map_literal
    return {
      'id': id,
      'title': title,
      'homeroom_id': homeRoomID,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}
