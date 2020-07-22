import 'package:flutter/material.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/homeroom_provider.dart';
import 'package:provider/provider.dart';

class DeleteClassRoomArguments {
  DeleteClassRoomArguments(this.homeRoom);
  final HomeRoom homeRoom;
}

class DeleteClassRoom extends StatelessWidget {
  static const routeName = '/admin/delete/class';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as DeleteClassRoomArguments;
    final config = AppStyle();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${args.homeRoom.grade}年 ${args.homeRoom.lectureClass}組 管理画面',
          style: TextStyle(
            fontSize: config.size4,
            color: config.st,
          ),
        ),
      ),
      body: ListView(children: <Widget>[
        _menuItemDelete(
          'このクラスの削除',
          Icon(Icons.delete),
          context,
          args.homeRoom.id,
        ),
      ]),
    );
  }
}

Widget _menuItemDelete(String title, Icon icon, BuildContext context, int id) {
  return Consumer<HomeRoomProvider>(builder: (context, counter, _) {
    return _MenuContainer(
      icon: icon,
      id: id,
      title: title,
    );
  });
}

class _MenuContainer extends StatelessWidget {
  const _MenuContainer({
    Key key,
    this.icon,
    this.title,
    this.id,
  }) : super(key: key);

  final Icon icon;
  final String title;
  final int id;
  @override
  Widget build(BuildContext context) {
    final homeRoomProvider = Provider.of<HomeRoomProvider>(context);

    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        onTap: () {
          deleteAlertPopUp(context, id, homeRoomProvider);
        },
      ),
    );
  }
}

Future<void> deleteAlertPopUp(
    BuildContext context, int id, HomeRoomProvider homeroom) async {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text('このクラスを削除'),
        content: const Text('この動作は一度行うと取り消すことができません。それでも削除しますか？'),
        actions: <Widget>[
          // ボタン領域
          FlatButton(
            child: const Text('キャンセル'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: const Text('削除する'),
            onPressed: () {
              homeroom.deleteHomeRoom(id);
              Navigator.pop(context);
              confirmPopUp(context);
            },
          ),
        ],
      );
    },
  );
}

Future<void> confirmPopUp(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          '削除しました',
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                'ホーム画面に戻ります。',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('確認'),
            onPressed: () {
              Navigator.popUntil(
                context,
                ModalRoute.withName('/home'),
              );
            },
          ),
        ],
      );
    },
  );
}
