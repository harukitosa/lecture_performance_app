import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/home/regist/registSeat.dart';

class HomeRegist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新規クラス登録"),
      ),
      body: HomeRegistView(),
    );
  }
}

class HomeRegistView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeForm();
  }
}

class ChangeForm extends StatefulWidget {
  ChangeForm({Key key}) : super(key: key);

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
      if (_grade != "" && _lectureClass != "") {
        validation = false;
      }
    });
  }

  void _handleLectureClass(String e) {
    setState(() {
      _lectureClass = e;
      if (_grade != "" && _lectureClass != "") {
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
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(60.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Color(0xFFFFaFaFaF),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.home,
                  color: Colors.black,
                  size: 90.0,
                ),
              ),
              Text('教室登録'),
              Container(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: '学年'),
                  onChanged: _handleGrade,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: '組'),
                  onChanged: _handleLectureClass,
                  style: TextStyle(
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
                  : Text(''),
              Container(
                padding: EdgeInsets.all(16.0),
                child: RaisedButton(
                  onPressed: () async {
                    if (_grade.isEmpty || _lectureClass.isEmpty) {
                      setState(() {
                        validation = true;
                      });
                    } else {
                      Navigator.pushNamed(
                        context,
                        HomeRegistSeat.routeName,
                        arguments:
                            HomeRegistSeatArgument(_grade, _lectureClass),
                      );
                    }
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
          ),
        ),
      ),
    );
  }
}
