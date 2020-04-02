// import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/ValuationProvider.dart';
import 'dart:core';
import "dart:async";
import 'package:badges/badges.dart';

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
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
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
      onLongPress: () {
        var text = "HEY LONG PRESS";
        Scaffold.of(context)
            .showSnackBar(_commonSnackBar(text, Colors.yellowAccent, 28));
      },
      onPanEnd: (details) async {
        if (flag == "true" && studentID != -1) {
          var x = valuationProvider.x;
          var y = valuationProvider.y;

          //下にスワイプ
          if (y > x.abs()) {
            valuationProvider.evaluation(studentID, typeID, -1);
            var text = name + "さんの" + title + "ポイントを下げました";
            classRoomProvider.badgeChange(index, Colors.redAccent, "-1pt");
            Scaffold.of(context)
                .showSnackBar(_commonSnackBar(text, Colors.redAccent, 28));
            await new Future.delayed(new Duration(milliseconds: 1700));
            classRoomProvider.badgeChange(index, Colors.redAccent, "-1pt");
          }

          //上にスワイプ
          if (y < -x.abs()) {
            valuationProvider.evaluation(studentID, typeID, 1);
            var text = name + "さんに" + title + "ポイントを付与しました";
            classRoomProvider.badgeChange(index, Colors.greenAccent, "+1pt");
            Scaffold.of(context)
                .showSnackBar(_commonSnackBar(text, Colors.greenAccent, 28));
            await new Future.delayed(new Duration(milliseconds: 1700));
            classRoomProvider.badgeChange(index, Colors.greenAccent, "+1pt");
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
      child: Stack(children: <Widget>[
        Container(
          margin: EdgeInsets.all(4.0),
          color: flag == "true" ? Colors.blue : Colors.grey,
          child: Center(
            child: Text(
              // 五文字以上なら先頭五文字のみ出力
              name.length > 5 ? name.substring(0, 5) : name,
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
        classRoomProvider.seatBadge != null
            ? Badge(
                badgeContent: Text(
                  classRoomProvider.seatBadge[index].text,
                  style: TextStyle(fontSize: 18),
                ),
                badgeColor: classRoomProvider.seatBadge[index].color,
                shape: BadgeShape.square,
                borderRadius: 20,
                toAnimate: true,
                animationType: BadgeAnimationType.fade,
                animationDuration: Duration(milliseconds: 1),
                showBadge: classRoomProvider.seatBadge[index].isShow,
              )
            : Text('')
      ]),
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
