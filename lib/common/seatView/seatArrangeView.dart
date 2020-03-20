// import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'dart:core';

class SeatArrangeView extends StatelessWidget {
  final String flag;
  final String name;
  final int studentID;
  final int index;
  final bool changeState;
  final int positionNum;

  SeatArrangeView(
    this.flag,
    this.index,
    this.name,
    this.changeState,
    this.studentID,
    this.positionNum,
  );

  @override
  Widget build(BuildContext context) {
    final classRoompro = Provider.of<ClassRoomProvider>(context);
    return positionNum != -1
        ? DragTarget(
            onAccept: (data) {
              classRoompro.seatArrangePointer(index);
            },
            builder: (context, candidateData, rejectedData) {
              return Draggable(
                onDragStarted: () {
                  classRoompro.seatArrangePointer(index);
                },
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Container(
                    color: flag == "true" ? Colors.blue : Colors.grey,
                    child: Center(
                      child: Text(
                        name,
                        style: TextStyle(
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
                        style: TextStyle(
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
            padding: EdgeInsets.all(4.0),
            child: Container(
              color: flag == "true" ? Colors.blue : Colors.grey,
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
            ),
          );
  }
}
