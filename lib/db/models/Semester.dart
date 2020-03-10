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
      homeRoomID: json["homeRoomID"],
      createTime: json["createTime"],
      updateTime: json["updateTime"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'title': title,
      'homeRoomID': homeRoomID,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }
}