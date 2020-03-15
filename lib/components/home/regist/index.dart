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

  void _handleGrade(String e) {
    setState(() {
      _grade = e;
    });
  }

  void _handleLectureClass(String e) {
    setState(() {
      _lectureClass = e;
    });
  }

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 450,
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
                    maxLengthEnforced: false,
                    style: TextStyle(color: Colors.black, fontSize: 40),
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
                    maxLengthEnforced: false,
                    style: TextStyle(color: Colors.black, fontSize: 40),
                    obscureText: false,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    onChanged: _handleLectureClass,
                  ),
                ),
              ],
            ),
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
                    Navigator.pushNamed(
                      context,
                      HomeRegistSeat.routeName,
                      arguments: HomeRegistSeatArgument(_grade, _lectureClass),
                    );
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

