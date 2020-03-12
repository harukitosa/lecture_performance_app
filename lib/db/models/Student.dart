class Student {

  final int id;
  final int homeRoomID;
  final String name;
  final int positionNum;
  final String createTime;
  String updateTime;

  Student({
    this.id,
    this.homeRoomID,
    this.name,
    this.positionNum,
    this.createTime,
    this.updateTime,
  });

  factory Student.fromMap(Map<String, dynamic> json) => new Student(
      id: json["id"],
      homeRoomID: json["homeroom_id"],
      name: json["name"],
      positionNum: json["position_num"],
      createTime: json["created_at"],
      updateTime: json["updated_at"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'id': id,
      'name': name,
      'position_num': positionNum,
      'homeroom_id': homeRoomID,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }

}