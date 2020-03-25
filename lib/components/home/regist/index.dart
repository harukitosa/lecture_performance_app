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

  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 9.0,
        child: Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(20.0),
          height: 400,
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "入力してください。",
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
                      "学年",
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
                      maxLengthEnforced: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                      ),
                      obscureText: false,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      onChanged: _handleGrade,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "組",
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
                      maxLengthEnforced: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                      ),
                      obscureText: false,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      onChanged: _handleLectureClass,
                    ),
                  ),
                ],
              ),
              validation != false
                  ? Text(
                      '値を入力してください。',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 18,
                      ),
                    )
                  : Text(""),
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: ButtonTheme(
                  minWidth: 300,
                  height: 50,
                  child: RaisedButton(
                    child: Text(
                      "次へ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    color: Colors.red,
                    textColor: Colors.white,
                    onPressed: () async {
                      if (_grade == "" || _lectureClass == "") {
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
