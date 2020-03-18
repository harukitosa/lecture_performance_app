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
        title:
            Text(args.homeRoom.grade + "年" + args.homeRoom.lectureClass + "組"),
        actions: <Widget>[],
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
                homeRoomID: args.homeRoom.id,
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
    return Center(
      child: Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 1000.0),
            child: SeatMap(
              homeRoomID: homeRoomID,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Container(
              width: 200,
              height: 50,
              color: Colors.redAccent,
              child: Center(
                child: Text(
                  "黒板",
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SeatMap extends StatelessWidget {
  final int homeRoomID;
  SeatMap({this.homeRoomID});
  @override
  Widget build(BuildContext context) {
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    final valuationProvider = Provider.of<EvaluationProvider>(context);
    classRoomProvider.getStudentData(homeRoomID);
    valuationProvider.getAllEvaluationType();
    String _name = "";
    int _studentID = 0;
    int _indexCount = 0;
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
            _name = classRoomProvider.studentList.length > index - _indexCount
                ? classRoomProvider.studentList[index - _indexCount].name
                : "";

            _studentID = classRoomProvider.studentList.length != null
                ? classRoomProvider.studentList.length > index - _indexCount
                    ? classRoomProvider.studentList[index - _indexCount].id
                    : 0
                : 0;
          } else {
            _indexCount++;
          }
          return ClassRoomSeatView(
            classRoomProvider.viewSeat[index].used,
            index,
            _name,
            true,
            _studentID,
          );
        },
      ),
    );
  }
}
