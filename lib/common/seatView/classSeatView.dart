// import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/ValuationProvider.dart';
import 'dart:core';

class ClassRoomSeatView extends StatelessWidget {
  final String flag;
  final String name;
  final int studentID;
  final int index;
  final bool changeState;

  ClassRoomSeatView(
    this.flag,
    this.index,
    this.name,
    this.changeState,
    this.studentID,
  );

  @override
  Widget build(BuildContext context) {
    // final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    final valuationProvider = Provider.of<EvaluationProvider>(context);
    return GestureDetector(
      onPanUpdate: (details) {
        valuationProvider.x = details.delta.dx;
        valuationProvider.y = details.delta.dy;
      },
      onPanEnd: (details) {
        if (flag == "true" && studentID != 0) {
          var x = valuationProvider.x;
          var y = valuationProvider.y;
          if (y > x.abs()) {
            var typeID = valuationProvider.currentTypeID;
            valuationProvider.evaluation(studentID, typeID, -1);
            final snackBar = SnackBar(
              content: Container(
                height: 120,
                child: Center(
                  child: Text(
                    name + "さんのポイントを下げました",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 1),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          }
          if (y < -x.abs()) {
            var typeID = valuationProvider.currentTypeID;
            valuationProvider.evaluation(studentID, typeID, 1);
            final snackBar = SnackBar(
              content: Container(
                height: 120,
                child: Center(
                  child: Text(
                    name + "さんにポイントを付与しました",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.greenAccent,
              duration: const Duration(seconds: 1),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          }
          if (x < -y.abs()) {
            final snackBar = SnackBar(
              content: Container(
                height: 120,
                child: Center(
                  child: Text(
                    "指名",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.yellowAccent,
              duration: const Duration(seconds: 1),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          }
          if (x > y.abs()) {
            final snackBar = SnackBar(
              content: Container(
                height: 120,
                child: Center(
                  child: Text(
                    "発言",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.yellowAccent,
              duration: const Duration(seconds: 1),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          }
          valuationProvider.x = 0.0;
          valuationProvider.y = 0.0;
        }
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
    );
  }
}
