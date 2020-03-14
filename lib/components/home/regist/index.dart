import 'package:flutter/material.dart';

class HomeRegist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _incrementCounter() {
      Navigator.pushNamed(context, '/');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("新規クラス登録"),
      ),
      body: Center(
        child: Text("hello"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}