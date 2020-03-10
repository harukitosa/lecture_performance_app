import 'package:flutter/material.dart';
import '../components/home/index.dart';
import '../components/classRoom/index.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/class': (context) => ClassRoom(),
      },
    );
  }
}