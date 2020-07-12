import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/popup/comfirmPopup.dart';
import 'package:lecture_performance_app/components/student/show/index.dart';
import 'package:lecture_performance_app/providers/StudentProvider.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:provider/provider.dart';

class EditStudentArgument {
  EditStudentArgument({this.studentID});
  int studentID;
}

class EditStudent extends StatelessWidget {
  static const routeName = '/admin/edit/student';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as EditStudentArgument;

    return Scaffold(
      appBar: AppBar(
        title: const Text('生徒情報編集画面'),
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
        title: const Text('この生徒を削除'),
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
              initStudentAPI().deletestudent(id);
              Navigator.pop(context);
              _confirmPopUp(context);
            },
          ),
        ],
      );
    },
  );
}

Future<void> _confirmPopUp(BuildContext context) async {
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
                // homeではない方がいいかも
                ModalRoute.withName('/home'),
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
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(60),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color(0xFFFFaFaFaF),
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
                      size: 90,
                    ),
                  ),
                  const Text('生徒情報編集'),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: '姓'),
                      initialValue: studentProvider.student.lastName,
                      onChanged: studentProvider.handleChangeLastName,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: '名前'),
                      initialValue: studentProvider.student.firstName,
                      onChanged: studentProvider.handleChangeFirstName,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: '出席番号'),
                      initialValue: studentProvider.student.number.toString(),
                      onChanged: studentProvider.handleChangeNum,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: RaisedButton(
                      onPressed: () {
                        studentProvider.updateStudent();
                        confirmPopUp(context, StudentShow.routeName);
                      },
                      color: Colors.redAccent,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        '保存',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const Text('NO DATA'),
      ),
    );
  }
}
