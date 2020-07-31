import 'dart:core';

import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/seat_edit_pos_provider.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:provider/provider.dart';

//routerで渡される値
class SeatUpdatePositionArgument {
  SeatUpdatePositionArgument(this.homeRoom);
  final HomeRoom homeRoom;
}

class SeatUpdatePosition extends StatelessWidget {
  static const routeName = '/admin/class/seat';
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as SeatUpdatePositionArgument;
    final seat = initSeatAPI();
    final student = initStudentAPI();
    return Scaffold(
      appBar: AppBar(
        title: Text('${args.homeRoom.grade}年 ${args.homeRoom.lectureClass}組'),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: SeatEditPosProvider(
              seat: seat,
              student: student,
              homeroomID: args.homeRoom.id,
            ),
          ),
        ],
        child: Consumer<SeatEditPosProvider>(
          builder: (context, counter, _) {
            return Center(
              child: EditPosSeatMap(
                homeRoomID: args.homeRoom != null ? args.homeRoom.id : -1,
              ),
            );
          },
        ),
      ),
    );
  }
}

class EditPosSeatMap extends StatelessWidget {
  const EditPosSeatMap({this.grade, this.lectureClass, this.homeRoomID});

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
    final seat = Provider.of<SeatEditPosProvider>(context);
    var _name = '';
    var _studentID = 0;
    var _indexCount = 0;
    var _positionNum = 0;
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: seat.list.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: seat.width ?? 7,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.4,
        ),
        itemBuilder: (context, index) {
          final students = seat.students;
          if (seat.list[index].used == 'true') {
            _name = students.length > index - _indexCount
                ? students[index - _indexCount].lastName
                : '';
            _studentID = students.length > index - _indexCount
                ? students[index - _indexCount].id
                : -1;
            _positionNum = students.length > index - _indexCount
                ? students[index - _indexCount].positionNum
                : -1;
          } else {
            _indexCount++;
            _name = '';
            _positionNum = -1;
            _studentID = -1;
          }
          return SeatArrangeView(
            flag: seat.list[index].used,
            name: _name,
            studentID: _studentID,
            changeState: true,
            positionNum: _positionNum,
          );
        },
      ),
    );
  }
}

class SeatArrangeView extends StatelessWidget {
  const SeatArrangeView({
    this.flag,
    this.name,
    this.studentID,
    this.changeState,
    this.positionNum,
  });

  final String flag;
  final String name;
  final int studentID;
  final bool changeState;
  final int positionNum;

  @override
  Widget build(BuildContext context) {
    final seat = Provider.of<SeatEditPosProvider>(context);
    return positionNum != -1
        ? DragTarget<void>(
            onAccept: (data) {
              seat.targetSeat(studentID);
            },
            builder: (context, candidateData, rejectedData) {
              return Draggable<void>(
                onDragStarted: () {
                  seat.targetSeat(studentID);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    color: flag == 'true' ? Colors.blue : Colors.grey,
                    child: Center(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                childWhenDragging: Container(),
                feedback: Material(
                  child: Container(
                    width: 200,
                    height: 70,
                    child: Center(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 28,
                        ),
                      ),
                    ),
                    color: Colors.yellow,
                  ),
                ),
              );
            },
          )
        : Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              color: flag == 'true' ? Colors.blue : Colors.grey,
              child: Center(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
            ),
          );
  }
}
