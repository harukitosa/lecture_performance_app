import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'package:lecture_performance_app/providers/ValuationProvider.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/common/seatView/SeatArrangeView.dart';

//routerで渡される値
class SeatArrangeArgument {
  SeatArrangeArgument(this.homeRoom);
  final HomeRoom homeRoom;
}

class SeatArrange extends StatelessWidget {
  static const routeName = '/admin/class/seat';
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as SeatArrangeArgument;
    return Scaffold(
      appBar: AppBar(
        title: Text('${args.homeRoom.grade}年 ${args.homeRoom.lectureClass}組'),
      ),
      body: MultiProvider(
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
            return Center(
              child: RegistSeatMap(
                homeRoomID: args.homeRoom != null ? args.homeRoom.id : -1,
              ),
            );
          },
        ),
      ),
    );
  }
}

class RegistSeatMap extends StatelessWidget {
  const RegistSeatMap({this.grade, this.lectureClass, this.homeRoomID});

  final String grade;
  final String lectureClass;
  final int homeRoomID;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              width: 800,
              color: Colors.white,
              child: const Center(
                child: Text(
                  '席替え',
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
            constraints: const BoxConstraints(maxHeight: 1000),
            child: SeatMap(
              homeRoomID: homeRoomID,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
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
  const SeatMap({this.homeRoomID});
  final int homeRoomID;
  @override
  Widget build(BuildContext context) {
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    // classRoomProvider.getStudentData(homeRoomID);
    var _name = '';
    var _studentID = 0;
    var _indexCount = 0;
    var _positionNum = 0;
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: classRoomProvider.viewSeat == null
            ? 0
            : classRoomProvider.viewSeat.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: classRoomProvider.viewWidth == null
              ? 7
              : classRoomProvider.viewWidth,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.4,
        ),
        itemBuilder: (context, index) {
          final studentList = classRoomProvider.studentList;
          if (classRoomProvider.viewSeat[index].used == 'true' &&
              studentList != null) {
            _name = studentList.length > index - _indexCount
                ? studentList[index - _indexCount].lastName
                : '';
            _studentID = studentList.length > index - _indexCount
                ? studentList[index - _indexCount].id
                : -1;
            _positionNum = studentList.length > index - _indexCount
                ? studentList[index - _indexCount].positionNum
                : -1;
          } else {
            _indexCount++;
            _name = '';
            _positionNum = -1;
            _studentID = -1;
          }
          return SeatArrangeView(
            flag: classRoomProvider.viewSeat[index].used,
            name: _name,
            studentID: _studentID,
            index: index - _indexCount,
            changeState: true,
            positionNum: _positionNum,
          );
        },
      ),
    );
  }
}
