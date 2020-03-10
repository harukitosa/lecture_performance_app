class Student {

  final int id;
  final int homeRoomID;
  final String name;
  final String createTime;
  String updateTime;

  Student({
    this.id,
    this.homeRoomID,
    this.name,
    this.createTime,
    this.updateTime,
  });

  factory Student.fromMap(Map<String, dynamic> json) => new Student(
      id: json["id"],
      homeRoomID: json["homeRoomID"],
      name: json["name"],
      createTime: json["createTime"],
      updateTime: json["updateTime"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'name': name,
      'homeRoomID': homeRoomID,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }

}