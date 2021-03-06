import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/popup/confirm_popup.dart';
import 'package:lecture_performance_app/components/student/show/index.dart';
import 'package:lecture_performance_app/db/models/student.dart';
import 'package:lecture_performance_app/providers/student_edit_provider.dart';
import 'package:lecture_performance_app/providers/student_show_provider.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:provider/provider.dart';

class StudentUpdateArgument {
  StudentUpdateArgument({this.studentID});
  int studentID;
}

class StudentUpdate extends StatelessWidget {
  static const routeName = '/admin/edit/student';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as StudentUpdateArgument;
    final student = initStudentAPI();
    final evaluation = initEvaluationAPI();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: StudentShowProvider(
            student: student,
            evaluation: evaluation,
            studentID: args.studentID,
          ),
        ),
      ],
      child: Consumer<StudentShowProvider>(
        builder: (context, counter, _) {
          return StudentUpdateBody(args: args);
        },
      ),
    );
//    return StudentUpdateBody(args: args);
  }
}

class StudentUpdateBody extends StatelessWidget {
  const StudentUpdateBody({
    Key key,
    @required this.args,
  }) : super(key: key);

  final StudentUpdateArgument args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生徒情報編集画面'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.delete,
              size: 32,
            ),
            onPressed: () {
              // _deleteStudentAlertPopUp(context, args.studentID);
            },
          ),
        ],
      ),
      body: Center(
        child: EditStudentView(),
      ),
    );
  }
}

/* 生徒削除　*/
// Future<void> _deleteStudentAlertPopUp(BuildContext context, int id) async {
//   final studentProvider = Provider.of<StudentShowProvider>(context);
//   return showDialog(
//     context: context,
//     builder: (_) {
//       return AlertDialog(
//         title: const Text('この生徒を削除'),
//         content: const Text('この動作は一度行うと取り消すことができません。それでも削除しますか？'),
//         actions: <Widget>[
//           // ボタン領域
//           FlatButton(
//             child: const Text('キャンセル'),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           FlatButton(
//             child: const Text('削除する'),
//             onPressed: () {
//               studentProvider.deleteStudent(id);
//               Navigator.pop(context);
//               Navigator.pop(context);
//               _confirmPopUp(context);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

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
    final args =
        ModalRoute.of(context).settings.arguments as StudentUpdateArgument;
    final studentProvider = Provider.of<StudentShowProvider>(context);
    final item = studentProvider.value;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: StudentEditProvider(
            firstName: item?.firstName ?? '',
            lastName: item?.lastName ?? '',
            number: item?.number.toString() ?? '',
          ),
        ),
      ],
      child: Consumer<StudentEditProvider>(
        builder: (context, counter, _) {
          return Center(
            child: item != null
                ? EditForm(
                    item: item,
                    studentProvider: studentProvider,
                  )
                : const Text('NOW LOADING'),
          );
        },
      ),
    );
  }
}

class EditForm extends StatelessWidget {
  const EditForm({
    Key key,
    @required this.item,
    @required this.studentProvider,
  }) : super(key: key);

  final Student item;
  final StudentShowProvider studentProvider;

  @override
  Widget build(BuildContext context) {
    final s = Provider.of<StudentEditProvider>(context);

    return Container(
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
      child: item != null
          ? Column(
              children: <Widget>[
                Container(
                  child: const Icon(
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
                    initialValue: item?.lastName ?? '',
                    onChanged: s.handleChangeLastName,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: '名前'),
                    initialValue: item?.firstName ?? '',
                    onChanged: s.handleChangeFirstName,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: '出席番号'),
                    initialValue: item?.number.toString() ?? '',
                    onChanged: s.handleChangeNum,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: RaisedButton(
                    onPressed: () {
                      // todo: int.parseのエラーハンドリングをStudentEditProviderに移す
                      studentProvider.updateStudent(
                        item.id,
                        s.lastName,
                        s.firstName,
                        int.parse(s.number),
                      );
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
    );
  }
}
