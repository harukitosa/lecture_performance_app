import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/admin/classroom/index.dart';
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
  @override
  Widget build(BuildContext context) {
    final ClassRoomArgument args = ModalRoute.of(context).settings.arguments;
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
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ClassRoomProvider(args.homeRoom.id),
          ),
          ChangeNotifierProvider(
            create: (_) => EvaluationProvider(),
          ),
        ],
        child: Consumer<ClassRoomProvider>(
          builder: (context, counter, _) {
            return Center(
              child: RegistSeatMap(
                homeRoomID: args.homeRoom != null ? args.homeRoom.id : -1,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AdminClassRoom.routeName,
            arguments: AdminClassRoomArgument(
              args.homeRoom,
            ),
          );
        },
        tooltip: 'Increment',
        label: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            '管理画面',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class RegistSeatMap extends StatelessWidget {
  final String grade;
  final String lectureClass;
  final int homeRoomID;
  RegistSeatMap({this.grade, this.lectureClass, this.homeRoomID});
  @override
  Widget build(BuildContext context) {
    final valuationProvider = Provider.of<EvaluationProvider>(context);
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Container(
              width: 800,
              color: Colors.white,
              child: Center(
                child: Text(
                  valuationProvider.getEvaluationSelect != null
                      ? valuationProvider
                          .getEvaluationSelect[valuationProvider.currentTypeID]
                          .title
                      : "",
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 20,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 1000.0),
            child: SeatMap(
              homeRoomID: homeRoomID,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
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
        ),
        Expanded(
          flex: 1,
          child: Container(),
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
    classRoomProvider.getStudentData(homeRoomID);
    String _name = "";
    int _studentID = 0;
    int _indexCount = 0;
    int _positionNum = 0;
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
          childAspectRatio: 2.4,
        ),
        itemBuilder: (context, index) {
          if (classRoomProvider.viewSeat[index].used == "true") {
            _name = classRoomProvider.studentList != null
                ? classRoomProvider.studentList.length > index - _indexCount
                    ? classRoomProvider.studentList[index - _indexCount].name
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
          } else {
            _indexCount++;
            _name = "";
            _positionNum = -1;
            _studentID = -1;
          }
          return ClassRoomSeatView(
            classRoomProvider.viewSeat != null
                ? classRoomProvider.viewSeat.length != 0
                    ? classRoomProvider.viewSeat[index].used
                    : false
                : false,
            index,
            _name,
            true,
            _studentID,
            _positionNum,
          );
        },
      ),
    );
  }
}
