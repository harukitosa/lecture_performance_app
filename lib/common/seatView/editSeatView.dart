import 'package:lecture_performance_app/providers/HomeRoomProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSeatView extends StatelessWidget {
  final String flag;
  final int index;
  final bool changeState;
  EditSeatView(this.flag, this.index, this.changeState);
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
    return InkWell(
      onTap: () {
        if (this.changeState) {
          homeRoomProvider.changeSeatState(index);
        }
      },
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
