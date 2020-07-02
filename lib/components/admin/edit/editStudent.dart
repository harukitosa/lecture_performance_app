import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/admin/classroom/studentDetail.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/StudentProvider.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:lecture_performance_app/services/student_service.dart';
import 'package:lecture_performance_app/common/popup/comfirmPopup.dart';

class EditStudentArgument {
  int studentID;
  EditStudentArgument({this.studentID});
}

class EditStudent extends StatelessWidget {
  static const routeName = '/admin/edit/student';

  @override
  Widget build(BuildContext context) {
    final EditStudentArgument args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("生徒情報編集画面"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              size: 32,
            ),
            onPressed: () {
              _deleteStudentAlertPopUp(context, args.studentID);
            },
          ),
        ],
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: StudentProvider(args.studentID),
          ),
        ],
        child: Consumer<StudentProvider>(
          builder: (context, counter, _) {
            return Center(
              child: EditStudentView(),
            );
          },
        ),
      ),
    );
  }
}

Future<void> _deleteStudentAlertPopUp(BuildContext context, int id) async {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text("この生徒を削除"),
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
              StudentService _studentServices = initStudentAPI();
              _studentServices.deletestudent(id);
              Navigator.pop(context);
              _confirmPopUp(context);
            },
          ),
        ],
      );
    },
  );
}

Future<void> _confirmPopUp(context) async {
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
                // homeではない方がいいかも
                ModalRoute.withName("/home"),
              );
            },
          ),
        ],
      );
    },
  );
}

class EditStudentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    return Center(
      child: Container(
        width: 500,
        height: 600,
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.all(60.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: Color(0xFFFFaFaFaF),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: studentProvider.student != null
            ? Column(
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 90.0,
                    ),
                  ),
                  Text('生徒情報編集'),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: '姓'),
                      initialValue: studentProvider.student.lastName,
                      onChanged: studentProvider.handleChangeLastName,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: '名前'),
                      initialValue: studentProvider.student.firstName,
                      onChanged: studentProvider.handleChangeFirstName,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: '出席番号'),
                      initialValue: studentProvider.student.number.toString(),
                      onChanged: studentProvider.handleChangeNum,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: RaisedButton(
                      onPressed: () {
                        studentProvider.updateStudent();
                        confirmPopUp(context, AdminStudentDetail.routeName);
                      },
                      color: Colors.redAccent,
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '保存',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Text("NO DATA"),
      ),
    );
  }
}
