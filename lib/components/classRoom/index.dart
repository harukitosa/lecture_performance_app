import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';

class ClassRoomArgument {
  final HomeRoom homeRoom;
  ClassRoomArgument(this.homeRoom);
}

class ClassRoom extends StatelessWidget {
  static const routeName = '/class';
  @override
  Widget build(BuildContext context) {
    final ClassRoomArgument args = ModalRoute.of(context).settings.arguments;
    void _incrementCounter() {
      Navigator.pushNamed(context, '/');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(args.homeRoom.grade.toString()+"年"+args.homeRoom.lectureClass.toString()+"組"),
      ),
      body: Center(
        child: Text(
          args.homeRoom.id.toString(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
