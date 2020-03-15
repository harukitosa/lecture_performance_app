// import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class ClassRoomSeatView extends StatelessWidget {
  final String flag;
  final int index;
  final bool changeState;
  ClassRoomSeatView(this.flag, this.index, this.changeState);
  @override
  Widget build(BuildContext context) {
    // final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Container(
          color: flag == "true" ? Colors.blue : Colors.grey,
          child: Text(""),
        ),
      ),
    );
  }
}
