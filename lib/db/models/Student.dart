class Student {
  final int id;
  final int homeRoomID;
  final String firstName;
  final String lastName;
  final int number;
  int positionNum;
  int evaluationSum;
  final String createTime;
  String updateTime;

  Student({
    this.id,
    this.homeRoomID,
    this.firstName,
    this.lastName,
    this.number,
    this.positionNum,
    this.createTime,
    this.updateTime,
  });

  set changePos(int posNum) {
    positionNum = posNum;
  }

  String get name => lastName + " " + firstName;

  factory Student.fromMap(Map<String, dynamic> json) => new Student(
        id: json["id"],
        homeRoomID: json["homeroom_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        number: json["number"],
        positionNum: json["position_num"],
        createTime: json["created_at"],
        updateTime: json["updated_at"],
      );

  Map<String, dynamic> toMapNew() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'number': number,
      'position_num': positionNum,
      'homeroom_id': homeRoomID,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}
