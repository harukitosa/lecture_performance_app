import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/seatView/class_seat_view.dart';
import 'package:lecture_performance_app/components/student/index/index.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/classroom_provider.dart';
import 'package:lecture_performance_app/providers/valuation_provider.dart';
import 'package:provider/provider.dart';

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
                RegistSeatMap(
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
class RegistSeatMap extends StatelessWidget {
  RegistSeatMap({this.grade, this.lectureClass, this.homeRoomID});
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
