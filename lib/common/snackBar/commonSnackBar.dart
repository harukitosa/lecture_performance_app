import 'package:flutter/material.dart';

/// commonSnackBar
/// 成績評価をした場合やundoをした時に下部に表示されるBar
SnackBar commonSnackBar(String text, Color color, double fontSize) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
    ),
    content: Container(
      height: 60,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSize,
          ),
        ),
      ),
    ),
    backgroundColor: color,
    duration: const Duration(milliseconds: 1000),
  );
}
