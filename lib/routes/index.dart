import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/homeroom/create/create_confirm.dart';
import 'package:lecture_performance_app/components/homeroom/create/create_seat.dart';
import 'package:lecture_performance_app/components/homeroom/create/index.dart';
import 'package:lecture_performance_app/components/homeroom/delete/index.dart';
import 'package:lecture_performance_app/components/homeroom/index/index.dart';
import 'package:lecture_performance_app/components/homeroom/show/index.dart';
import 'package:lecture_performance_app/components/seat/update/update_position.dart';
import 'package:lecture_performance_app/components/seat/update/update_used.dart';
import 'package:lecture_performance_app/components/student/create/create_many_student.dart';
import 'package:lecture_performance_app/components/student/create/index.dart';
import 'package:lecture_performance_app/components/student/index/index.dart';
import 'package:lecture_performance_app/components/student/show/index.dart';
import 'package:lecture_performance_app/components/student/update/index.dart';

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
        SeatUpdatePosition.routeName: (_) => SeatUpdatePosition(),
        StudentCreate.routeName: (_) => StudentCreate(),
        StudentsCreate.routeName: (_) => StudentCreate(),
        StudentUpdate.routeName: (_) => StudentUpdate(),
        SeatUpdateUsed.routeName: (_) => const SeatUpdateUsed(),
        HomeroomShow.routeName: (_) => HomeroomShow(),
      },
    );
  }
}
