import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/admin/classroom/index.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';

//routerで渡される値
class RegistStudentArgument {
  final HomeRoom homeRoom;
  RegistStudentArgument(this.homeRoom);
}

class RegistStudent extends StatelessWidget {
  static const routeName = '/admin/regist/student';
  @override
  Widget build(BuildContext context) {
    final RegistStudentArgument args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.homeRoom.grade + "年" + args.homeRoom.lectureClass + "組 新規生徒登録",
        ),
        actions: <Widget>[],
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ClassRoomProvider(args.homeRoom.id),
          ),
        ],
        child: Consumer<ClassRoomProvider>(
          builder: (context, counter, _) {
            return Center(
              child: _InputForm(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        tooltip: 'Increment',
        label: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'まとめて追加',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

class _InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<_InputForm> {
  String _name = '';
  String _number = '';
  int id;

  void _handleName(String e) {
    setState(() {
      _name = e;
    });
  }

  void _handleNumber(String e) {
    setState(() {
      _number = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    final RegistStudentArgument args =
        ModalRoute.of(context).settings.arguments;
    return Center(
      child: Container(
        height: 450,
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "生徒情報を入力してください。",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "名前",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: new TextField(
                    enabled: true,
                    maxLength: 10,
                    maxLengthEnforced: false,
                    style: TextStyle(color: Colors.black, fontSize: 40),
                    obscureText: false,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    onChanged: _handleName,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "出席番号",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: new TextField(
                    enabled: true,
                    maxLength: 10,
                    maxLengthEnforced: false,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black, fontSize: 40),
                    obscureText: false,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    onChanged: _handleNumber,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: ButtonTheme(
                minWidth: 300,
                height: 50,
                child: RaisedButton(
                  child: Text(
                    "保存する",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () async {
                    classRoomProvider.registStudentData(
                        args.homeRoom.id, int.parse(_number), _name);
                    _confirmPopUp(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _confirmPopUp(context) async {
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
                ModalRoute.withName(AdminClassRoom.routeName),
              );
            },
          ),
        ],
      );
    },
  );
}
