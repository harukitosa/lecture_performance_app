import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/home/index/index.dart';
import 'package:lecture_performance_app/components/classRoom/index.dart';
import 'package:lecture_performance_app/components/home/regist/index.dart';
import 'package:lecture_performance_app/components/home/regist/registSeat.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/home/regist': (context) => HomeRegist(),
        HomeRegistSeat.routeName: (_) => HomeRegistSeat(),
        ClassRoom.routeName: (_) => ClassRoom(),
      },
    );
  }
}
