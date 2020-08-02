import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/student/create/create_many_student.dart';
import 'package:lecture_performance_app/db/models/homeroom.dart';
import 'package:lecture_performance_app/providers/student_create_provider.dart';
import 'package:lecture_performance_app/providers/student_edit_provider.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:provider/provider.dart';

//routerで渡される値
class StudentCreateArgument {
  StudentCreateArgument(this.homeRoom);
  final HomeRoom homeRoom;
}

class StudentCreate extends StatelessWidget {
  static const routeName = '/admin/create/student';
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as StudentCreateArgument;
    final student = initStudentAPI();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${args.homeRoom.grade}年 ${args.homeRoom.lectureClass}組 新規生徒登録',
        ),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: StudentCreateProvider(
              student: student,
            ),
          ),
          ChangeNotifierProvider.value(
            value: StudentEditProvider(
              firstName: '',
              lastName: '',
              number: '',
            ),
          ),
        ],
        child: Consumer<StudentCreateProvider>(
          builder: (context, counter, _) {
            return Center(
              child: StoreStudentForm(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            StudentsCreate.routeName,
            arguments: StudentsCreateArgument(
              args.homeRoom,
            ),
          );
        },
        tooltip: 'Increment',
        label: const Padding(
          padding: EdgeInsets.all(12),
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

class StoreStudentForm extends StatefulWidget {
  @override
  _StoreStudentFormState createState() => _StoreStudentFormState();
}

class _StoreStudentFormState extends State<StoreStudentForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final editor = Provider.of<StudentEditProvider>(context);
    final student = Provider.of<StudentCreateProvider>(context);
    final args =
        ModalRoute.of(context).settings.arguments as StudentCreateArgument;
    return Container(
      child: Center(
        child: Container(
          width: 500,
          height: 900,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(60),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color(0xFFFFaFaFaF),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  child: const Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 90,
                  ),
                ),
                const Text('生徒登録'),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: '姓'),
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                    onChanged: editor.handleChangeLastName,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '名前を記入してください。';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: '名'),
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                    onChanged: editor.handleChangeFirstName,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '名前を記入してください。';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: '出席番号'),
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                    onChanged: editor.handleChangeNum,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '番号を記入してください。';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        student.createStudent(
                          args.homeRoom.id,
                          editor.firstName,
                          editor.lastName,
                          int.parse(editor.number),
                        );
                        await _confirmPopUp(context);
                      }
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
            ),
          ),
        ),
      ),
    );
  }
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
