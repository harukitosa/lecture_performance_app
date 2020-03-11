class Semester {

  final int id;
  final int homeRoomID;
  final String title;
  final String createTime;
  String updateTime;

  Semester({
    this.id,
    this.homeRoomID,
    this.title,
    this.createTime,
    this.updateTime,
  });

  factory Semester.fromMap(Map<String, dynamic> json) => new Semester(
      id: json["id"],
      title: json["title"],
      homeRoomID: json["homeroom_id"],
      createTime: json["created_at"],
      updateTime: json["updated_at"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'id': id,
      'title': title,
      'homeroom_id': homeRoomID,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}