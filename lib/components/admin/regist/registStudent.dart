import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/popup/comfirmPopup.dart';
import 'package:lecture_performance_app/components/admin/classroom/index.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'package:lecture_performance_app/components/admin/regist/registStudents.dart';
import 'package:flutter/services.dart';

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
        onPressed: () {
          Navigator.pushNamed(
            context,
            RegistStudents.routeName,
            arguments: RegistStudentsArgument(
              args.homeRoom,
            ),
          );
        },
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
  bool _validation = false;

  void _handleName(String e) {
    setState(() {
      _name = e;
      if (_name != "" && _number != "") {
        _validation = false;
      }
    });
  }

  void _handleNumber(String e) {
    setState(() {
      _number = e;
      if (_name != "" && _number != "") {
        _validation = false;
      }
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
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
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
            _validation == true
                ? Text('記入してください。',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ))
                : Text(''),
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
                    if (_name == "" || _number == "") {
                      setState(() {
                        _validation = true;
                      });
                    } else {
                      classRoomProvider.registStudentData(
                        args.homeRoom.id,
                        int.parse(_number),
                        _name,
                      );
                      confirmPopUp(context, AdminClassRoom.routeName);
                    }
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
