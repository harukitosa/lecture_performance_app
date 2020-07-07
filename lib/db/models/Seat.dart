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

  factory Seat.fromMap(Map<String, dynamic> json) => Seat(
        id: json['id'] as int,
        homeRoomID: json['homeroom_id'] as int,
        used: json['used'] as String,
        createTime: json['created_at'] as String,
        updateTime: json['updated_at'] as String,
      );

  Map<String, String> toMapNew() {
    return {
      'id': id as String,
      'homeroom_id': homeRoomID as String,
      'used': used,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}
