import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/admin/classroom/index.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'package:lecture_performance_app/providers/ValuationProvider.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/common/seatView/classSeatView.dart';

//routerで渡される値
class ClassRoomArgument {
  final HomeRoom homeRoom;
  ClassRoomArgument(this.homeRoom);
}

class ClassRoom extends StatelessWidget {
  static const routeName = '/class';
  final config = AppStyle();
  @override
  Widget build(BuildContext context) {
    final ClassRoomArgument args = ModalRoute.of(context).settings.arguments;
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
                args.homeRoom.grade + "年" + args.homeRoom.lectureClass + "組",
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                RegistSeatMap(
                  homeRoomID: args.homeRoom != null ? args.homeRoom.id : -1,
                ),
              ],
            ),
            floatingActionButton: new Builder(
              builder: (BuildContext context) {
                return FloatingActionButton.extended(
                  onPressed: () {
                    classRoomProvider.undo(context);
                  },
                  tooltip: 'Increment',
                  label: Padding(
                    padding: EdgeInsets.all(12.0),
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

class RegistSeatMap extends StatelessWidget {
  final String grade;
  final String lectureClass;
  final int homeRoomID;
  final config = AppStyle();
  RegistSeatMap({this.grade, this.lectureClass, this.homeRoomID});
  @override
  Widget build(BuildContext context) {
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    final ClassRoomArgument args = ModalRoute.of(context).settings.arguments;
    return Column(
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100.0),
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
                        AdminClassRoom.routeName,
                        arguments: AdminClassRoomArgument(
                          args.homeRoom,
                        ),
                      );
                    },
                    child: Text(
                      "管理画面",
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
            maxHeight: 800.0,
            maxWidth: classRoomProvider.viewWidth == null
                ? 700.0
                : (classRoomProvider.viewWidth * 170).toDouble(),
          ),
          child: Container(
            child: SeatMap(
              homeRoomID: homeRoomID,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Container(
            width: 200,
            height: 50,
            color: Colors.brown,
            child: Center(
              child: Text(
                "教卓",
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
  final int homeRoomID;
  SeatMap({this.homeRoomID});
  @override
  Widget build(BuildContext context) {
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    // classRoomProvider.getStudentData(homeRoomID);
    classRoomProvider.getSeatData(homeRoomID);
    String _name = "";
    int _studentID = 0;
    int _indexCount = 0;
    int _positionNum = 0;
    String _viewSeat = "false";
    Color _seatColor = Colors.green;
    return Padding(
      padding: EdgeInsets.only(top: 40.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: classRoomProvider.viewSeat == null
            ? 0
            : classRoomProvider.viewSeat.length,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 50),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: classRoomProvider.viewWidth == null
              ? 7
              : classRoomProvider.viewWidth,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          if (classRoomProvider.viewSeat != null &&
              classRoomProvider.viewSeat[index] != null &&
              classRoomProvider.viewSeat[index].used == "true") {
            _name = classRoomProvider.studentList != null
                ? classRoomProvider.studentList.length > index - _indexCount
                    ? classRoomProvider
                        .studentList[index - _indexCount].lastName
                    : ""
                : "";

            _studentID = classRoomProvider.studentList != null
                ? classRoomProvider.studentList.length > index - _indexCount
                    ? classRoomProvider.studentList[index - _indexCount].id
                    : -1
                : -1;
            _positionNum = classRoomProvider.studentList != null
                ? classRoomProvider.studentList.length > index - _indexCount
                    ? classRoomProvider
                        .studentList[index - _indexCount].positionNum
                    : -1
                : -1;
            _viewSeat = classRoomProvider.viewSeat != null
                ? classRoomProvider.viewSeat.length != 0
                    ? classRoomProvider.viewSeat[index].used
                    : "false"
                : "false";
            _seatColor = classRoomProvider.studentList != null
                ? classRoomProvider.studentList.length > index - _indexCount
                    ? classRoomProvider.studentList[index - _indexCount]
                        .seatColor()
                    : Colors.blueAccent
                : Colors.blueAccent;
          } else {
            _indexCount++;
            _name = "";
            _positionNum = -1;
            _studentID = -1;
            _viewSeat = "false";
            _seatColor = Colors.blueAccent;
          }
          return ClassRoomSeatView(
            _viewSeat,
            index,
            _name,
            true,
            _studentID,
            _positionNum,
            _seatColor,
            index - _indexCount,
          );
        },
      ),
    );
  }
}

