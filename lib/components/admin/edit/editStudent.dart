import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/popup/comfirmPopup.dart';
import 'package:lecture_performance_app/components/admin/classroom/studentDetail.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/StudentProvider.dart';

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
        actions: <Widget>[],
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => StudentProvider(args.studentID),
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
        child: Column(
          children: <Widget>[
            Container(
              child: Icon(
                Icons.person,
                color: Colors.black,
                size: 90.0,
              ),
            ),
            Text('生徒情報編集'),
            studentProvider.student != null
                ? Container(
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: '名前'),
                      initialValue: studentProvider.student.lastName,
                      onChanged: studentProvider.handleChangeLastName,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  )
                : Text('Now Loading'),
            studentProvider.student != null
                ? Container(
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: '出席番号'),
                      initialValue: studentProvider.student.number.toString(),
                      onChanged: studentProvider.handleChangeNum,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  )
                : Text('Now Loading'),
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
        ),
      ),
    );
  }
}
