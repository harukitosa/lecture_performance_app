class HomeRoom {
  
  final int id;
  final int userID;
  final int grade;
  final int lectureClass;
  final String createTime;
  String updateTime;
  String deleteTime;

  HomeRoom({
    this.id,
    this.userID,
    this.grade,
    this.lectureClass,
    this.createTime,
    this.updateTime,
    this.deleteTime,
  });

  factory HomeRoom.fromMap(Map<String, dynamic> json) => new HomeRoom(
      id: json["id"],
      userID: json["userID"],
      grade: json["grade"],
      lectureClass: json["lectureClass"],
      createTime: json["createTime"],
      updateTime: json["updateTime"],
      deleteTime: json["deleteTime"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'userID': userID,
      'grade': grade,
      'lectureClass': lectureClass,
      'createTime': createTime,
      'updateTime': updateTime,
      'delteTime': deleteTime,
    };
  }
}