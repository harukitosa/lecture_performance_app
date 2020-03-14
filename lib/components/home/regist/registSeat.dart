import 'package:flutter/material.dart';

//routerで渡される値
class HomeRegistSeatArgument {
  final int homeRoomID;
  HomeRegistSeatArgument(this.homeRoomID);
}

class HomeRegistSeat extends StatelessWidget {
  static const routeName = '/home/regist/seat';
  @override
  Widget build(BuildContext context) {
    final HomeRegistSeatArgument arg = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(arg.homeRoomID.toString()),
      ),
      body: Text('座席の指定'),
    );
  }
}
