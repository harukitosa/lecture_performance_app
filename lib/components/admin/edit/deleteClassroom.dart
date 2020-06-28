import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/services/homeroom_service.dart';
import 'package:lecture_performance_app/wire.dart';

class DeleteClassRoomArguments {
  final HomeRoom homeRoom;
  DeleteClassRoomArguments(this.homeRoom);
}

class DeleteClassRoom extends StatelessWidget {
  static const routeName = '/admin/delete/class';

  @override
  Widget build(BuildContext context) {
    final DeleteClassRoomArguments args =
        ModalRoute.of(context).settings.arguments;
    final config = AppStyle();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.homeRoom.grade + "年" + args.homeRoom.lectureClass + "組 管理画面",
          style: TextStyle(
            fontSize: config.size4,
            color: config.st,
          ),
        ),
      ),
      body: ListView(children: <Widget>[
        _menuItemDelete(
          "このクラスの削除",
          Icon(Icons.delete),
          context,
          args.homeRoom.id,
        ),
      ]),
    );
  }
}

Widget _menuItemDelete(String title, Icon icon, BuildContext context, int id) {
  return Container(
    decoration: new BoxDecoration(
        border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
    child: ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
      onTap: () {
        deleteAlertPopUp(context, id);
      },
    ),
  );
}

Future<void> deleteAlertPopUp(BuildContext context, int id) async {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text("このクラスを削除"),
        content: Text("この動作は一度行うと取り消すことができません。それでも削除しますか？"),
        actions: <Widget>[
          // ボタン領域
          FlatButton(
            child: Text("キャンセル"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("削除する"),
            onPressed: () {
              HomeRoomService hs = initHomeRoomAPI();
              hs.deleteHomeRoom(id);
              Navigator.pop(context);
              confirmPopUp(context);
            },
          ),
        ],
      );
    },
  );
}

Future<void> confirmPopUp(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          '削除しました',
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'ホーム画面に戻ります。',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('確認'),
            onPressed: () {
              Navigator.popUntil(
                context,
                ModalRoute.withName("/home"),
              );
            },
          ),
        ],
      );
    },
  );
}
