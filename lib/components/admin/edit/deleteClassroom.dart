import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';

class DeleteClassRoomArguments {
  final HomeRoom homeroom;
  DeleteClassRoomArguments(this.homeroom);
}

class DeleteClassRoom extends StatelessWidget {
  static const routeName = '/admin/delete/class';

  @override
  Widget build(BuildContext context) {
    final DeleteClassRoomArguments args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.homeroom.grade + " " + args.homeroom.lectureClass),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
