import 'dart:core';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/student/index/index.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/classroom_provider.dart';
import 'package:lecture_performance_app/providers/valuation_provider.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/common/snackBar/common_snack_bar.dart';

//routerで渡される値
class HomeroomShowArgument {
  HomeroomShowArgument(this.homeRoom);
  final HomeRoom homeRoom;
}

@immutable
class HomeroomShow extends StatelessWidget {
  static const routeName = '/class';
  final AppStyle config = AppStyle();
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as HomeroomShowArgument;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ClassRoomProvider(args.homeRoom.id),
        ),
        ChangeNotifierProvider.value(
          value: EvaluationProvider(),
        ),
      ],
      child: Consumer<ClassRoomProvider>(
        builder: (context, counter, _) {
          final classRoomProvider = Provider.of<ClassRoomProvider>(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '${args.homeRoom.grade} 年 ${args.homeRoom.lectureClass} 組',
              ),
            ),
            body: Column(
              children: <Widget>[
                SaveSeatMap(
                  grade: args.homeRoom.grade,
                  lectureClass: args.homeRoom.lectureClass,
                  homeRoomID: args.homeRoom != null ? args.homeRoom.id : -1,
                ),
              ],
            ),
            floatingActionButton: Builder(
              builder: (BuildContext context) {
                return FloatingActionButton.extended(
                  onPressed: () {
                    classRoomProvider.undo(context);
                  },
                  tooltip: 'Increment',
                  label: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Undo',
                      style: TextStyle(
                        fontSize: config.size4,
                        color: config.st,
                      ),
                    ),
                  ),
                  backgroundColor: config.pd,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

@immutable
class SaveSeatMap extends StatelessWidget {
  SaveSeatMap({this.grade, this.lectureClass, this.homeRoomID});
  final String grade;
  final String lectureClass;
  final int homeRoomID;
  final AppStyle config = AppStyle();
  @override
  Widget build(BuildContext context) {
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);

    final args =
        ModalRoute.of(context).settings.arguments as HomeroomShowArgument;
    final lastName = classRoomProvider.sta.isNotEmpty
        ? classRoomProvider.sta.top().student.lastName
        : '';
    final point = classRoomProvider.sta.isNotEmpty
        ? classRoomProvider.sta.top().point.toString()
        : '';
    return Column(
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: config.pl,
                ),
                width: 200,
                height: 50,
                child: Center(
                  child: Text(
                    classRoomProvider.sta.isNotEmpty
                        ? '$lastName:$point'
                        : 'NOACTION',
                    style: TextStyle(
                      fontSize: config.size4,
                      color: config.st,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                  ),
                  color: config.s,
                ),
                width: 200,
                height: 50,
                child: Center(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        StudentIndex.routeName,
                        arguments: StudentIndexArgument(
                          args.homeRoom,
                        ),
                      );
                    },
                    child: Text(
                      '管理画面',
                      style: TextStyle(
                        fontSize: config.size4,
                        color: config.st,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 800,
            maxWidth: classRoomProvider.viewWidth == null
                ? 700.0
                : (classRoomProvider.viewWidth * 170).toDouble(),
          ),
          child: Container(
            child: SeatMap(
              homeRoomID: homeRoomID != null ? homeRoomID : 0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            width: 200,
            height: 50,
            color: Colors.brown,
            child: Center(
              child: Text(
                '教卓',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SeatMap extends StatelessWidget {
  const SeatMap({this.homeRoomID});
  final int homeRoomID;
  @override
  Widget build(BuildContext context) {
    // crp: classRoomProvider
    final crp = Provider.of<ClassRoomProvider>(context);

    var _name = '';
    var _studentID = 0;
    var _indexCount = 0;
    var _positionNum = 0;
    var _viewSeat = 'false';
    Color _seatColor = Colors.green;

    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: crp.viewSeat == null ? 0 : crp.viewSeat.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crp.viewWidth == null ? 7 : crp.viewWidth,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          if (crp.viewSeat[index].used == 'true' &&
              crp.studentList.length > index - _indexCount) {
            _name = crp.studentList[index - _indexCount].lastName;
            _studentID = crp.studentList[index - _indexCount].id;
            _positionNum = crp.studentList[index - _indexCount].positionNum;
            _seatColor = crp.studentList[index - _indexCount].seatColor();
            _viewSeat = crp.viewSeat[index].used;
          } else {
            _indexCount++;
            _name = '';
            _positionNum = -1;
            _studentID = -1;
            _viewSeat = 'false';
            _seatColor = Colors.blueAccent;
          }
          return ClassRoomSeatView(
            _viewSeat,
            index,
            _name,
            _studentID,
            _positionNum,
            _seatColor,
            index - _indexCount,
            changeState: true,
          );
        },
      ),
    );
  }
}

class ClassRoomSeatView extends StatelessWidget {
  const ClassRoomSeatView(
    this.flag,
    this.index,
    this.name,
    this.studentID,
    this.positionNum,
    this.seatColor,
    this.stuIndex, {
    this.changeState,
  });

  final String flag;
  final String name;
  final int studentID;
  final int index;
  final bool changeState;
  final int positionNum;
  final Color seatColor;
  final int stuIndex;

  @override
  Widget build(BuildContext context) {
    final valuationProvider = Provider.of<EvaluationProvider>(context);
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    final typeID = valuationProvider.currentTypeID != null
        ? valuationProvider.currentTypeID + 1
        : 1;

    return GestureDetector(
      onDoubleTap: () {
        classRoomProvider.evaluation(studentID, typeID, 0, stuIndex);
        final text = '$nameさんの回答にチェックを付けました';
        classRoomProvider.badgeChange(index, Colors.yellowAccent, '0pt');
        Scaffold.of(context)
            .showSnackBar(commonSnackBar(text, Colors.yellowAccent, 28));
      },
      onPanUpdate: (details) {
        valuationProvider
          ..x = details.delta.dx
          ..y = details.delta.dy;
      },
      onPanEnd: (details) {
        if (flag == 'true' && studentID != -1) {
          final x = valuationProvider.x;
          final y = valuationProvider.y;

          //下にスワイプ
          if (y > x.abs()) {
            classRoomProvider
              ..evaluation(studentID, typeID, -1, stuIndex)
              ..badgeChange(index, Colors.redAccent, '-1pt');
            Scaffold.of(context).showSnackBar(
                commonSnackBar('$nameさんの回答ポイントを減らしました', Colors.redAccent, 28));
          }

          //上にスワイプ
          if (y < -x.abs()) {
            classRoomProvider.evaluation(studentID, typeID, 2, stuIndex);
            final text = '$nameさんに回答ポイントを付与しました';
            classRoomProvider.badgeChange(index, Colors.greenAccent, '+2pt');
            Scaffold.of(context)
                .showSnackBar(commonSnackBar(text, Colors.greenAccent, 28));
          }

          //左にスワイプ
          if (x < -y.abs()) {
            classRoomProvider
              ..evaluation(studentID, typeID + 1, 1, stuIndex)
              ..badgeChange(index, Colors.greenAccent, '+1pt');
            Scaffold.of(context).showSnackBar(
              commonSnackBar(
                '$nameさんに積極的ポイントを付与しました',
                Colors.greenAccent,
                28,
              ),
            );
          }

          //右にスワイプ
          if (x > y.abs()) {
            classRoomProvider
              ..evaluation(studentID, typeID, 1, stuIndex)
              ..badgeChange(index, Colors.greenAccent, '+1pt');
            Scaffold.of(context).showSnackBar(
              commonSnackBar(
                '$nameさんに回答ポイントを付与しました',
                Colors.greenAccent,
                28,
              ),
            );
          }
          valuationProvider
            ..x = 0.0
            ..y = 0.0;
        }
      },
      child: Stack(children: <Widget>[
        Container(
          margin: const EdgeInsets.all(4),
          color: flag == 'true' ? seatColor : Colors.grey,
          child: Center(
            child: Text(
              // 五文字以上なら先頭五文字のみ出力
              name.length > 7 ? name.substring(0, 7) : name,
              style: const TextStyle(
                fontSize: 22,
              ),
            ),
          ),
        ),
        classRoomProvider.seatBadge != null
            ? Badge(
                badgeContent: Text(
                  classRoomProvider.seatBadge[index].text,
                  style: const TextStyle(fontSize: 18),
                ),
                badgeColor: classRoomProvider.seatBadge[index].color,
                shape: BadgeShape.square,
                borderRadius: 20,
                toAnimate: true,
                animationType: BadgeAnimationType.fade,
                animationDuration: const Duration(milliseconds: 1),
                showBadge: classRoomProvider.seatBadge[index].isShow,
              )
            : const Text('')
      ]),
    );
  }
}
