import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/popup/comfirmPopup.dart';
import 'package:lecture_performance_app/components/admin/classroom/index.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'package:lecture_performance_app/components/admin/regist/registStudents.dart';

//routerで渡される値
class RegistStudentArgument {
  RegistStudentArgument(this.homeRoom);
  final HomeRoom homeRoom;
}

class RegistStudent extends StatelessWidget {
  static const routeName = '/admin/regist/student';
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as RegistStudentArgument;
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
            return Center(
              child: RegistStudentForm(),
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

class RegistStudentForm extends StatefulWidget {
  const RegistStudentForm({Key key}) : super(key: key);

  @override
  _RegistStudentFormState createState() => _RegistStudentFormState();
}

class _RegistStudentFormState extends State<RegistStudentForm> {
  String _firstName = '';
  String _lastName = '';
  String _number = '';
  int id;
  bool _validation = false;

  void _handleFirstName(String e) {
    setState(() {
      _firstName = e;
      if (_firstName != "" && _number != "") {
        _validation = false;
      }
    });
  }

  void _handleLastName(String e) {
    setState(() {
      _lastName = e;
      if (_lastName != "" && _number != "" && _firstName != "") {
        _validation = false;
      }
    });
  }

  void _handleNumber(String e) {
    setState(() {
      _number = e;
      if (_firstName != "" && _number != "" && _lastName != "") {
        _validation = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    final args =
        ModalRoute.of(context).settings.arguments as RegistStudentArgument;
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
                    size: 90.0,
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
                  padding: const EdgeInsets.all(16.0),
                  child: RaisedButton(
                    onPressed: () async {
                      if (_firstName == "" ||
                          _number == "" ||
                          _lastName == "") {
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
                        await confirmPopUp(context, AdminClassRoom.routeName);
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
