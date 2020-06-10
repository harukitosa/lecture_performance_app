class Seat {
  final int id;
  final int homeRoomID;
  final String used;
  final String createTime;
  String updateTime;

  Seat({
    this.id,
    this.homeRoomID,
    this.used,
    this.createTime,
    this.updateTime,
  });

  factory Seat.fromMap(Map<String, dynamic> json) => new Seat(
        id: json["id"],
        homeRoomID: json["homeroom_id"],
        used: json["used"],
        createTime: json["created_at"],
        updateTime: json["updated_at"],
      );

  Map<String, dynamic> toMapNew() {
    return {
      'id': id,
      'homeroom_id': homeRoomID,
      'used': used,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}
