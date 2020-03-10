class Student {

  final int id;
  final int homeRoomID;
  final String name;
  final String createTime;
  String updateTime;
  String deleteTime;

  Student({
    this.id,
    this.homeRoomID,
    this.name,
    this.createTime,
    this.updateTime,
    this.deleteTime,
  });

  factory Student.fromMap(Map<String, dynamic> json) => new Student(
      id: json["id"],
      homeRoomID: json["homeRoomID"],
      name: json["name"],
      createTime: json["createTime"],
      updateTime: json["updateTime"],
      deleteTime: json["deleteTime"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'name': name,
      'homeRoomID': homeRoomID,
      'createTime': createTime,
      'updateTime': updateTime,
      'delteTime': deleteTime,
    };
  }

}