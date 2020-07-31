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
      final _twoHoursBefore = _now.subtract(const Duration(hours: 2));
      final _oneWeekBefore = _now.subtract(const Duration(days: 7));
      final _last = DateTime.parse(lastTime);
      if (_twoHoursBefore.compareTo(_last) < 0) {
        return Colors.cyan;
      } else {
        if (_oneWeekBefore.compareTo(_last) < 0) {
          return Colors.yellow[200];
        } else {
          return Colors.pink[400];
        }
      }
    }
    return Colors.pink[400];
  }

  String get name => lastName + firstName;

  Map<String, dynamic> toMapNew() {
    // ignore: implicit_dynamic_map_literal
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
