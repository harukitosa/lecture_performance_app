import 'package:flutter/material.dart';


// routeは確認後、遷移画面urlを指定する。
Future<void> confirmPopUp(context, route) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          '登録完了しました',
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                '管理画面に戻ります。',
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
                ModalRoute.withName(route),
              );
            },
          ),
        ],
      );
    },
  );
}