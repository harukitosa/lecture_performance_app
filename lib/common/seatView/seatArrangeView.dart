import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'dart:core';

class SeatArrangeView extends StatelessWidget {
  const SeatArrangeView({
    this.flag,
    this.name,
    this.studentID,
    this.index,
    this.changeState,
    this.positionNum,
  });

  final String flag;
  final String name;
  final int studentID;
  final int index;
  final bool changeState;
  final int positionNum;

  @override
  Widget build(BuildContext context) {
    final classRoompro = Provider.of<ClassRoomProvider>(context);
    return positionNum != -1
        ? DragTarget<void>(
            onAccept: (data) {
              classRoompro.seatArrangePointer(index);
            },
            builder: (context, candidateData, rejectedData) {
              return Draggable<void>(
                onDragStarted: () {
                  classRoompro.seatArrangePointer(index);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
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
