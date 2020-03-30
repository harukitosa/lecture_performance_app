import 'package:flutter/material.dart';

class AppDataConfig {
  static const _seatNum = 49;
  int get seatNum => (_seatNum);
  static const _seatWidth = 7;
  int get seatWidth => (_seatWidth);
}

/// AppStyle
///
/// p: primary color
/// pl: primary light color
/// pd: primary dark color
/// s: secondary color
/// sl: secondary light color
/// sd: secondary dark color
class AppStyle {
  /// color
  static const _p = Color(0xff03a9f4);
  static const _pl = Color(0xff67daff);
  static const _pd = Color(0xff007ac1);
  static const _s = Color(0xff512da8);
  static const _sl = Color(0xff8559da);
  static const _sd = Color(0xff140078);
  static const _pt = Color(0xff000000);
  static const _st = Color(0xffffffff);
  Color get p => _p;
  Color get pl => _pl;
  Color get pd => _pd;
  Color get s => _s;
  Color get sl => _sl;
  Color get sd => _sd;
  Color get pt => _pt;
  Color get st => _st;
  /// font-size
  static const _size1 = 48.0;
  static const _size2 = 40.0;
  static const _size3 = 32.0;
  static const _size4 = 24.0;
  static const _size5 = 16.0;
  static const _size6 = 8.0;
  double get size1 => _size1;
  double get size2 => _size2;
  double get size3 => _size3;
  double get size4 => _size4;
  double get size5 => _size5;
  double get size6 => _size6;
}
