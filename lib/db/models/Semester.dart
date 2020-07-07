class Semester {
  Semester({
    this.id,
    this.homeRoomID,
    this.title,
    this.createTime,
    this.updateTime,
  });
  final int id;
  final int homeRoomID;
  final String title;
  final String createTime;
  String updateTime;

  factory Semester.fromMap(Map<String, dynamic> json) => Semester(
        id: json['id'] as int,
        title: json['title'] as String,
        homeRoomID: json['homeroom_id'] as int,
        createTime: json['created_at'] as String,
        updateTime: json['updated_at'] as String,
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
