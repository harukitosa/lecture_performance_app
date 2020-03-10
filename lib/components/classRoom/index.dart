import 'package:flutter/material.dart';

class ClassRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      void _incrementCounter() {
          Navigator.pushNamed(context, '/');
      }
    return Scaffold(
      appBar: AppBar(
        title: Text("Class"),
      ),
      body: Center(
        child: 
          Text(
            'HelloWorld',
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