import 'package:flutter/material.dart';

/// 保存後の確認popup component
/// 
/// 確認後[route]で受け取ったルーティングに飛ばす
/// 
/// example
/// ```
/// confirmPopUp(context, AdminClassRoom.routeName);
/// ```
/// 
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