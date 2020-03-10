class Semester {

  final int id;
  final int homeRoomID;
  final String title;
  final String createTime;
  String updateTime;
  String deleteTime;

  Semester({
    this.id,
    this.homeRoomID,
    this.title,
    this.createTime,
    this.updateTime,
    this.deleteTime,
  });

  factory Semester.fromMap(Map<String, dynamic> json) => new Semester(
      id: json["id"],
      homeRoomID: json["homeRoomID"],
      createTime: json["createTime"],
      updateTime: json["updateTime"],
      deleteTime: json["deleteTime"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'title': title,
      'homeRoomID': homeRoomID,
      'createTime': createTime,
      'updateTime': updateTime,
      'delteTime': deleteTime,
    };
  }
}