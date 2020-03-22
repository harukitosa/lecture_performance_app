// import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/ValuationProvider.dart';
import 'dart:core';

class ClassRoomSeatView extends StatelessWidget {
  final String flag;
  final String name;
  final int studentID;
  final int index;
  final bool changeState;
  final int positionNum;

  ClassRoomSeatView(
    this.flag,
    this.index,
    this.name,
    this.changeState,
    this.studentID,
    this.positionNum,
  );

  @override
  Widget build(BuildContext context) {
    final valuationProvider = Provider.of<EvaluationProvider>(context);
    // ポイントの名前
    var title = valuationProvider
        .getEvaluationSelect[valuationProvider.currentTypeID].title;
    var typeID = valuationProvider.currentTypeID + 1;

    return GestureDetector(
      onDoubleTap: () {
        valuationProvider.evaluation(studentID, typeID, 0);
        var text = name + "さんに" + title + "のチェックを付けました";
        Scaffold.of(context)
            .showSnackBar(_commonSnackBar(text, Colors.yellowAccent, 28));
      },
      onPanUpdate: (details) {
        valuationProvider.x = details.delta.dx;
        valuationProvider.y = details.delta.dy;
      },
      onPanEnd: (details) {
        if (flag == "true" && studentID != -1) {
          var x = valuationProvider.x;
          var y = valuationProvider.y;

          //下にスワイプ
          if (y > x.abs()) {
            valuationProvider.evaluation(studentID, typeID, -1);
            var text = name + "さんの" + title + "ポイントを下げました";
            Scaffold.of(context)
                .showSnackBar(_commonSnackBar(text, Colors.redAccent, 28));
          }

          //上にスワイプ
          if (y < -x.abs()) {
            valuationProvider.evaluation(studentID, typeID, 1);
            var text = name + "さんに" + title + "ポイントを付与しました";
            Scaffold.of(context)
                .showSnackBar(_commonSnackBar(text, Colors.greenAccent, 28));
          }

          //左にスワイプ
          if (x < -y.abs()) {
            valuationProvider.changeTypeLeft();
            Scaffold.of(context).showSnackBar(
              _commonSnackBar(
                valuationProvider
                    .getEvaluationSelect[valuationProvider.currentTypeID].title,
                Colors.yellowAccent,
                28,
              ),
            );
          }

          //右にスワイプ
          if (x > y.abs()) {
            valuationProvider.changeTypeRight();
            Scaffold.of(context).showSnackBar(
              _commonSnackBar(
                valuationProvider
                    .getEvaluationSelect[valuationProvider.currentTypeID].title,
                Colors.yellowAccent,
                28,
              ),
            );
          }
          valuationProvider.x = 0.0;
          valuationProvider.y = 0.0;
        }
      },
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Container(
          color: flag == "true" ? Colors.blue : Colors.grey,
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

SnackBar _commonSnackBar(String text, Color color, double fontSize) {
  return SnackBar(
    content: Container(
      height: 120,
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
    duration: const Duration(seconds: 1),
  );
}
