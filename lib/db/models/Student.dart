import 'package:flutter/material.dart';
import 'package:lecture_performance_app/utility/time.dart';

class Student {
  final int id;
  final int homeRoomID;
  final String firstName;
  final String lastName;
  final int number;
  final String createTime;
  String updateTime;
  int positionNum;

  /// 合計の成績値
  int evaluationSum;

  /// 最後に当たった時間
  String lastTime;

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

  /// seatColor()
  /// 生徒の座席の色を返す
  /// 成績をつけた最新の時間が
  /// 二時間以内 blueAccent
  /// 二時間より経過 greenAccent
  /// 二週間経過 orangeAccesnt
  Color seatColor() {
    var _n = getNowTime();
    DateTime _now = DateTime.parse(_n);
    if (lastTime != null) {
      var _twohoursBefore = _now.subtract(new Duration(hours: 2));
      var _oneweekBefore = _now.subtract(new Duration(days: 7));
      DateTime _last = DateTime.parse(lastTime);
      if (_twohoursBefore.compareTo(_last) < 0) {
        return Colors.blueAccent;
      } else {
        if (_oneweekBefore.compareTo(_last) < 0) {
          return Colors.greenAccent;
        } else {
          return Colors.orangeAccent;
        }
      }
    }
    return Colors.orangeAccent;
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
