class Seat {

  final int id;
  final String used;
  final String createTime;
  String updateTime;

  Seat({
    this.id,
    this.used,
    this.createTime,
    this.updateTime,
  });

  factory Seat.fromMap(Map<String, dynamic> json) => new Seat(
      id: json["id"],
      used: json["used"],
      createTime: json["created_at"],
      updateTime: json["updated_at"],
  );

  Map<String, dynamic> toMapNew() {
    return {
      'id': id,
      'used': used,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}