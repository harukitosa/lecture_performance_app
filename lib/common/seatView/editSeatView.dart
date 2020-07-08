import 'package:lecture_performance_app/providers/HomeRoomProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSeatView extends StatelessWidget {
  const EditSeatView(this.flag, this.index, {this.changeState});

  final String flag;
  final int index;
  final bool changeState;
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);
    return InkWell(
      onTap: () {
        if (changeState) {
          homeRoomProvider.changeSeatState(index);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          color: flag == 'true' ? Colors.blue : Colors.grey,
          child: const Text(''),
        ),
      ),
    );
  }
}
