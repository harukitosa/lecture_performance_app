import 'dart:core';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/Header.dart';
import 'package:lecture_performance_app/common/snackBar/common_snack_bar.dart';
import 'package:lecture_performance_app/components/student/index/index.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/db/models/homeroom.dart';
import 'package:lecture_performance_app/providers/homeroom_show_provider.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:provider/provider.dart';

//routerで渡される値
class HomeroomShowArgument {
  HomeroomShowArgument(this.homeRoom);
  final HomeRoom homeRoom;
}

///  HomeroomShow
///  このページで使用するProviderの登録
@immutable
class HomeroomShow extends StatelessWidget {
  static const routeName = '/class';
  final AppStyle config = AppStyle();
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as HomeroomShowArgument;
    final student = initStudentWithEvaluationServiceAPI();
    final seat = initSeatAPI();
    final evaluation = initEvaluationAPI();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: HomeRoomShowProvider(
            student: student,
            seat: seat,
            evaluation: evaluation,
            homeroomID: args.homeRoom.id,
          ),
        ),
      ],
      child: Consumer<HomeRoomShowProvider>(
        builder: (context, counter, _) {
          return HomeRoomShowBody(args: args, config: config);
        },
      ),
    );
  }
}

/// HomeRoomShowBody
/// 表示を担当する
class HomeRoomShowBody extends StatelessWidget {
  const HomeRoomShowBody({
    Key key,
    @required this.args,
    @required this.config,
  }) : super(key: key);

  final HomeroomShowArgument args;
  final AppStyle config;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeRoomShowProvider>(context);

    void _onTap() {
      Navigator.pushNamed(
        context,
        StudentIndex.routeName,
        arguments: StudentIndexArgument(
          args.homeRoom,
        ),
      ).then((value) {
        provider.update();
      });
    }

    return Scaffold(
      appBar: Header(
        title: '${args.homeRoom.grade} 年 ${args.homeRoom.lectureClass} 組',
        onTap: _onTap,
        actionIcon: const Icon(
          Icons.settings,
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
              provider.undo(context);
            },
            tooltip: 'Increment',
            label: const Padding(
              padding: EdgeInsets.all(32),
              child: Icon(Icons.replay, size: 42),
            ),
            backgroundColor: config.pd,
          );
        },
      ),
    );
  }
}

/// _SubHeader
/// 情報を表示するHeader
@immutable
class _SubHeader extends StatelessWidget {
  _SubHeader({Key key, this.list}) : super(key: key);
  final List<String> list;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _FrequencyBar(),
        _UndoList(list: list),
      ],
    );
  }
}

///  _FrequencyBar
///  指名頻度を表示するBar
class _FrequencyBar extends StatelessWidget {
  const _FrequencyBar({Key key}) : super(key: key);
  final double _height = 40;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: _height,
          width: 80,
          child: Center(
            child: Text(
              '指名頻度',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          height: _height,
          width: 20,
          child: Center(
            child: Text('多'),
          ),
        ),
        Container(
          height: _height,
          width: 20,
          color: Colors.cyan,
        ),
        SizedBox(width: 4),
        Container(
          height: _height,
          width: 20,
          color: Colors.yellow[200],
        ),
        SizedBox(width: 4),
        Container(
          height: _height,
          width: 20,
          color: Colors.pink[400],
        ),
        SizedBox(width: 4),
        Container(
          height: _height,
          width: 20,
          color: Colors.purpleAccent,
        ),
        Container(
          height: _height,
          width: 20,
          child: Center(
            child: Text('少'),
          ),
        ),
      ],
    );
  }
}

class _UndoList extends StatelessWidget {
  const _UndoList({Key key, this.list}) : super(key: key);
  final List<String> list;
  List<Widget> _list() {
    final List<Widget> _widgetList = [];
    list.forEach((element) {
      _widgetList.add(_StackView(element));
    });
    return _widgetList;
  }

  Widget _StackView(String text) {
    return Container(
      height: 40,
      width: 80,
      color: Colors.blue[100],
      margin: const EdgeInsets.only(right: 2),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _list(),
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
    final provider = Provider.of<HomeRoomShowProvider>(context);
    final allStack = provider.sta;
    print(allStack);
    final args =
        ModalRoute.of(context).settings.arguments as HomeroomShowArgument;
    // final lastName =
    //     provider.sta.isNotEmpty ? provider.sta.top().student.lastName : '';
    // final point =
    //     provider.sta.isNotEmpty ? provider.sta.top().point.toString() : '';
    // print(provider.sta.length);
    return Column(
      children: <Widget>[
        _SubHeader(list: provider.undoStudent),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 800,
            maxWidth: (provider.width * 170).toDouble(),
          ),
          child: Container(
            child: SeatMap(
              homeRoomID: args.homeRoom.id,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            width: 200,
            height: 50,
            color: Colors.brown,
            child: const Center(
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
    final provider = Provider.of<HomeRoomShowProvider>(context);

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
        itemCount: provider.list.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: provider.width,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          if (provider.list[index].used == 'true' &&
              provider.list.length > index - _indexCount &&
              provider.students.length > index - _indexCount) {
            _name = '${provider.students[index - _indexCount].lastName} '
                '${provider.students[index - _indexCount].firstName}';
            _studentID = provider.students[index - _indexCount].id;
            _positionNum = provider.students[index - _indexCount].positionNum;
            _seatColor = provider.students[index - _indexCount].seatColor();
            _viewSeat = provider.list[index].used;
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
    final provider = Provider.of<HomeRoomShowProvider>(context);
    return GestureDetector(
      onDoubleTap: () {
        provider.evaluation(studentID, 1, 0, stuIndex);
        final text = '$nameさんの回答にチェックを付けました';
        provider.badgeChange(index, Colors.yellowAccent, '0pt');
        Scaffold.of(context)
            .showSnackBar(commonSnackBar(text, Colors.yellowAccent, 28));
      },
      onPanUpdate: (details) {
        provider
          ..x = details.delta.dx
          ..y = details.delta.dy;
      },
      onPanEnd: (details) {
        if (flag == 'true' && studentID != -1) {
          final x = provider.x;
          final y = provider.y;

          //下にスワイプ
          if (y > x.abs()) {
            provider
              ..evaluation(studentID, 1, -1, stuIndex)
              ..badgeChange(index, Colors.redAccent, '-1pt');
            Scaffold.of(context).showSnackBar(
                commonSnackBar('$nameさんの回答ポイントを減らしました', Colors.redAccent, 28));
          }

          //上にスワイプ
          if (y < -x.abs()) {
            provider.evaluation(studentID, 1, 3, stuIndex);
            final text = '$nameさんに回答ポイントを付与しました';
            provider.badgeChange(index, Colors.greenAccent, '+3pt');
            Scaffold.of(context)
                .showSnackBar(commonSnackBar(text, Colors.greenAccent, 28));
          }

          //左にスワイプ
          if (x < -y.abs()) {
            provider
              ..evaluation(studentID, 1, 0, stuIndex)
              ..badgeChange(index, Colors.greenAccent, '0pt');
            Scaffold.of(context).showSnackBar(
              commonSnackBar(
                '$nameさんに回答ポイントを付与しました',
                Colors.greenAccent,
                28,
              ),
            );
          }

          //右にスワイプ
          if (x > y.abs()) {
            provider
              ..evaluation(studentID, 1, 1, stuIndex)
              ..badgeChange(index, Colors.greenAccent, '+1pt');
            Scaffold.of(context).showSnackBar(
              commonSnackBar(
                '$nameさんに回答ポイント1ptを付与しました',
                Colors.greenAccent,
                28,
              ),
            );
          }
          provider
            ..x = 0.0
            ..y = 0.0;
        }
      },
      child: Stack(
        children: <Widget>[
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
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              color: Colors.white,
              width: 40,
              height: 25,
              child: Center(
                child: _scoreText(provider.studentScoreSum[studentID]),
              ),
            ),
          ),
          Badge(
            badgeContent: Text(
              provider.seatBadge[index].text,
              style: const TextStyle(fontSize: 18),
            ),
            badgeColor: provider.seatBadge[index].color,
            shape: BadgeShape.square,
            borderRadius: 20,
            toAnimate: true,
            animationType: BadgeAnimationType.fade,
            animationDuration: const Duration(milliseconds: 1),
            showBadge: provider.seatBadge[index].isShow,
          )
        ],
      ),
    );
  }
}

Widget _scoreText(int value) {
  if (value == null) {
    return const Text('');
  }
  return Text(
    '$value',
    style: const TextStyle(fontSize: 18),
  );
}
