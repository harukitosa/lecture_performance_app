import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/popup/confirm_popup.dart';
import 'package:lecture_performance_app/components/student/create/create_many_student.dart';
import 'package:lecture_performance_app/components/student/index/index.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/classroom_provider.dart';
import 'package:provider/provider.dart';

//routerで渡される値
class StudentCreateArgument {
  StudentCreateArgument(this.homeRoom);
  final HomeRoom homeRoom;
}

class StudentCreate extends StatelessWidget {
  static const routeName = '/admin/regist/student';
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as StudentCreateArgument;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${args.homeRoom.grade}年 ${args.homeRoom.lectureClass}組 新規生徒登録',
        ),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: ClassRoomProvider(args.homeRoom.id),
          ),
        ],
        child: Consumer<ClassRoomProvider>(
          builder: (context, counter, _) {
            return const Center(
              child: StoreStudentForm(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            StudentCreate.routeName,
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
  const StoreStudentForm({Key key}) : super(key: key);

  @override
  _StoreStudentFormState createState() => _StoreStudentFormState();
}

class _StoreStudentFormState extends State<StoreStudentForm> {
  String _firstName = '';
  String _lastName = '';
  String _number = '';
  int id;
  bool _validation = false;

  void _handleFirstName(String e) {
    setState(() {
      _firstName = e;
      if (_firstName != '' && _number != '') {
        _validation = false;
      }
    });
  }

  void _handleLastName(String e) {
    setState(() {
      _lastName = e;
      if (_lastName != '' && _number != '' && _firstName != '') {
        _validation = false;
      }
    });
  }

  void _handleNumber(String e) {
    setState(() {
      _number = e;
      if (_firstName != '' && _number != '' && _lastName != '') {
        _validation = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    final args =
        ModalRoute.of(context).settings.arguments as StudentsCreateArgument;
    return Container(
      child: Container(
        child: Center(
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
            child: Column(
              children: <Widget>[
                Container(
                  child: Icon(
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
                    onChanged: _handleLastName,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: '名'),
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                    onChanged: _handleFirstName,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: '出席番号'),
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                    onChanged: _handleNumber,
                  ),
                ),
                _validation == true
                    ? Text(
                        '値を入力してください。',
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      )
                    : const Text(''),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: RaisedButton(
                    onPressed: () async {
                      if (_firstName == '' ||
                          _number == '' ||
                          _lastName == '') {
                        setState(() {
                          _validation = true;
                        });
                      } else {
                        await classRoomProvider.registStudentData(
                          args.homeRoom.id,
                          int.parse(_number),
                          _firstName,
                          _lastName,
                        );
                        await confirmPopUp(context, StudentIndex.routeName);
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
