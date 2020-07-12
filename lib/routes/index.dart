import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/admin/classroom/seatArrange.dart';
import 'package:lecture_performance_app/components/admin/edit/deleteClassroom.dart';
import 'package:lecture_performance_app/components/admin/edit/editSeat.dart';
import 'package:lecture_performance_app/components/admin/edit/editStudent.dart';
import 'package:lecture_performance_app/components/admin/regist/registStudents.dart';
import 'package:lecture_performance_app/components/homeroom/create/create_confirm.dart';
import 'package:lecture_performance_app/components/homeroom/create/create_seat.dart';
import 'package:lecture_performance_app/components/homeroom/create/index.dart';
import 'package:lecture_performance_app/components/homeroom/index/index.dart';
import 'package:lecture_performance_app/components/homeroom/show/index.dart';
import 'package:lecture_performance_app/components/student/create/index.dart';
import 'package:lecture_performance_app/components/student/index/index.dart';
import 'package:lecture_performance_app/components/student/show/index.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeroomIndex(),
        '/home/regist': (context) => HomeroomCreate(),
        DeleteClassRoom.routeName: (_) => DeleteClassRoom(),
        HomeStoreSeat.routeName: (_) => HomeStoreSeat(),
        HomeStoreConfirm.routeName: (_) => HomeStoreConfirm(),
        StudentIndex.routeName: (_) => StudentIndex(),
        StudentShow.routeName: (_) => StudentShow(),
        SeatArrange.routeName: (_) => SeatArrange(),
        StudentCreate.routeName: (_) => StudentCreate(),
        StoreStudents.routeName: (_) => StoreStudents(),
        EditStudent.routeName: (_) => EditStudent(),
        EditSeat.routeName: (_) => const EditSeat(),
        HomeroomShow.routeName: (_) => HomeroomShow(),
      },
    );
  }
}
