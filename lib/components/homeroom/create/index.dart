import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/homeroom/create/create_seat.dart';

class HomeroomCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規クラス登録'),
      ),
      body: HomeStoreView(),
    );
  }
}

class HomeStoreView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ChangeForm();
  }
}

class ChangeForm extends StatefulWidget {
  const ChangeForm({Key key}) : super(key: key);

  @override
  _ChangeFormState createState() => _ChangeFormState();
}

class _ChangeFormState extends State<ChangeForm> {
  String _grade = '';
  String _lectureClass = '';
  int id;
  bool validation = false;

  void _handleGrade(String e) {
    setState(() {
      _grade = e;
      if (_grade != '' && _lectureClass != '') {
        validation = false;
      }
    });
  }

  void _handleLectureClass(String e) {
    setState(() {
      _lectureClass = e;
      if (_grade != '' && _lectureClass != '') {
        validation = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Icons.home,
                  color: Colors.black,
                  size: 90,
                ),
              ),
              const Text('教室登録'),
              Container(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: '学年'),
                  onChanged: _handleGrade,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: '組'),
                  onChanged: _handleLectureClass,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              validation == true
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
                    if (_grade.isEmpty || _lectureClass.isEmpty) {
                      setState(() {
                        validation = true;
                      });
                    } else {
                      await Navigator.pushNamed(
                        context,
                        HomeStoreSeat.routeName,
                        arguments: HomeStoreSeatArgument(_grade, _lectureClass),
                      );
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
    );
  }
}
