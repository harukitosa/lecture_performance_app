import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/popup/confirm_popup.dart';
import 'package:lecture_performance_app/components/student/index/index.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/student_create_provider.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

//routerで渡される値
class StudentsCreateArgument {
  StudentsCreateArgument(this.homeRoom);
  final HomeRoom homeRoom;
}

class StudentsCreate extends StatelessWidget {
  static const routeName = '/csv/create/students';
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as StudentsCreateArgument;
    final student = initStudentAPI();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${args.homeRoom.grade}年 ${args.homeRoom.lectureClass} 組 まとめて登録',
        ),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: StudentCreateProvider(student: student),
          ),
        ],
        child: Consumer<StudentCreateProvider>(
          builder: (context, counter, _) {
            return Center(
              child: _InputForm(),
            );
          },
        ),
      ),
    );
  }
}

class _InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<_InputForm> {
  String display = '';
  String fileText = '';
  File file;
  int id;
  AppStyle config = AppStyle();

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentCreateProvider>(context);
    final args =
        ModalRoute.of(context).settings.arguments as StudentsCreateArgument;

    /// csvファイルでデータの登録を行っている
    /// [num][lastName][firstName]の順番に登録していく。
    Future<void> _storeButton() async {
      List<String> data;
      data = fileText.replaceAll('\n', ',').split(',');
      for (var i = 0; i < data.length; i += 3) {
        try {
          final num = int.parse(data[i]);
          student.createStudent(
            args.homeRoom.id,
            num.toString(),
            data[i + 2],
            int.parse(data[i + 1]),
          );
        } on Exception catch (exception) {
          print(exception);
        }
      }
      await confirmPopUp(context, StudentIndex.routeName);
      setState(() {
        display = '';
      });
    }

    Future<void> _uploadFile() async {
      // ファイルの取得
      file = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      // ファイルの中身を取得
      if (file != null) {
        fileText = await file.readAsString();
        setState(() {
          display = basename(file.path);
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 300,
          width: 400,
          child: Column(
            children: <Widget>[
              Text(
                '.csv形式のファイルを選択してください。',
                style: TextStyle(fontSize: config.size3),
              ),
              Text(
                '一行目に出席番号、二行目に姓、三行目に名前を書き込んでください。',
                style: TextStyle(fontSize: config.size4),
              ),
            ],
          ),
        ),
        FlatButton(
          height: 50,
          color: Colors.blueAccent,
          textColor: Colors.white,
          child: Text(
            'ファイル選択・取り込み',
            style: TextStyle(fontSize: config.size4),
          ),
          shape: const StadiumBorder(),
          onPressed: _uploadFile,
        ),
        Text(display),
        FlatButton(
          height: 50,
          color: Colors.redAccent,
          textColor: Colors.white,
          shape: const StadiumBorder(),
          child: Text(
            '保存',
            style: TextStyle(fontSize: config.size4),
          ),
          onPressed: _storeButton,
        ),
      ],
    );
  }
}
