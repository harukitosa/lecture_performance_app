import 'package:flutter/material.dart';
import 'package:lecture_performance_app/utility/time.dart';

class Student {
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
  factory Student.fromMap(Map<String, dynamic> json) => Student(
        id: json['id'] as int,
        homeRoomID: json['homeroom_id'] as int,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        number: json['number'] as int,
        positionNum: json['position_num'] as int,
        createTime: json['created_at'] as String,
        updateTime: json['updated_at'] as String,
      );
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
    final _n = getNowTime();
    final _now = DateTime.parse(_n);
    if (lastTime != null) {
      final _twohoursBefore = _now.subtract(const Duration(hours: 2));
      final _oneweekBefore = _now.subtract(const Duration(days: 7));
      final _last = DateTime.parse(lastTime);
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

  String get name => lastName + firstName;

  Map<String, String> toMapNew() {
    return {
      'id': id as String,
      'first_name': firstName,
      'last_name': lastName,
      'number': number as String,
      'position_num': positionNum as String,
      'homeroom_id': homeRoomID as String,
      'created_at': createTime,
      'updated_at': updateTime,
    };
  }
}
