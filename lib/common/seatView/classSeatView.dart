import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/snackBar/commonSnackBar.dart';
import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/ValuationProvider.dart';
import 'dart:core';
import 'package:badges/badges.dart';

class ClassRoomSeatView extends StatelessWidget {
  final String flag;
  final String name;
  final int studentID;
  final int index;
  final bool changeState;
  final int positionNum;
  final Color seatColor;
  final int stuIndex;

  ClassRoomSeatView(
    this.flag,
    this.index,
    this.name,
    this.changeState,
    this.studentID,
    this.positionNum,
    this.seatColor,
    this.stuIndex,
  );

  @override
  Widget build(BuildContext context) {
    final valuationProvider = Provider.of<EvaluationProvider>(context);
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    var typeID = valuationProvider.currentTypeID != null
        ? valuationProvider.currentTypeID + 1
        : 1;

    return GestureDetector(
      onDoubleTap: () {
        classRoomProvider.evaluation(studentID, typeID, 0, stuIndex);
        var text = name + "さんの回答にチェックを付けました";
        classRoomProvider.badgeChange(index, Colors.yellowAccent, "0pt");
        Scaffold.of(context)
            .showSnackBar(commonSnackBar(text, Colors.yellowAccent, 28));
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
            classRoomProvider.evaluation(studentID, typeID, -1, stuIndex);
            classRoomProvider.badgeChange(index, Colors.redAccent, "-1pt");
            Scaffold.of(context).showSnackBar(commonSnackBar(
                name + "さんの回答ポイントを減らしました", Colors.redAccent, 28));
          }

          //上にスワイプ
          if (y < -x.abs()) {
            classRoomProvider.evaluation(studentID, typeID, 2, stuIndex);
            var text = name + "さんに回答ポイントを付与しました";
            classRoomProvider.badgeChange(index, Colors.greenAccent, "+2pt");
            Scaffold.of(context)
                .showSnackBar(commonSnackBar(text, Colors.greenAccent, 28));
          }

          //左にスワイプ
          if (x < -y.abs()) {
            classRoomProvider.evaluation(studentID, typeID + 1, 1, stuIndex);
            classRoomProvider.badgeChange(index, Colors.greenAccent, "+1pt");
            Scaffold.of(context).showSnackBar(
              commonSnackBar(
                name + "さんに積極的ポイントを付与しました",
                Colors.greenAccent,
                28,
              ),
            );
          }

          //右にスワイプ
          if (x > y.abs()) {
            classRoomProvider.evaluation(studentID, typeID, 1, stuIndex);
            classRoomProvider.badgeChange(index, Colors.greenAccent, "+1pt");
            Scaffold.of(context).showSnackBar(
              commonSnackBar(
                name + "さんに回答ポイントを付与しました",
                Colors.greenAccent,
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
          color: flag == "true" ? seatColor : Colors.grey,
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

