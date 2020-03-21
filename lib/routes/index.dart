import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/admin/classroom/seatArrange.dart';
import 'package:lecture_performance_app/components/admin/classroom/studentDetail.dart';
import 'package:lecture_performance_app/components/admin/regist/registStudent.dart';
import 'package:lecture_performance_app/components/admin/regist/registStudents.dart';
import 'package:lecture_performance_app/components/home/index/index.dart';
import 'package:lecture_performance_app/components/classRoom/index/index.dart';
import 'package:lecture_performance_app/components/home/regist/index.dart';
import 'package:lecture_performance_app/components/home/regist/registConfirm.dart';
import 'package:lecture_performance_app/components/home/regist/registSeat.dart';
import 'package:lecture_performance_app/components/admin/classroom/index.dart';

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
        '/home': (context) => new Home(),
        '/home/regist': (context) => HomeRegist(),
        HomeRegistSeat.routeName: (_) => HomeRegistSeat(),
        HomeRegistConfirm.routeName: (_) => HomeRegistConfirm(),
        AdminClassRoom.routeName: (_) => AdminClassRoom(),
        AdminStudentDetail.routeName: (_) => AdminStudentDetail(),
        SeatArrange.routeName: (_) => SeatArrange(),
        RegistStudent.routeName: (_) => RegistStudent(),
        RegistStudents.routeName: (_) => RegistStudents(),
        ClassRoom.routeName: (_) => ClassRoom(),
      },
    );
  }
}
