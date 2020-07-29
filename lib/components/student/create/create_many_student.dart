import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/popup/confirm_popup.dart';
import 'package:lecture_performance_app/components/student/index/index.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/classroom_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

//routerで渡される値
class StudentsCreateArgument {
  StudentsCreateArgument(this.homeRoom);
  final HomeRoom homeRoom;
}

class StudentsCreate extends StatelessWidget {
  static const routeName = '/admin/regist/students';
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as StudentsCreateArgument;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${args.homeRoom.grade}年 ${args.homeRoom.lectureClass} 組 まとめて登録',
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
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    final args =
        ModalRoute.of(context).settings.arguments as StudentsCreateArgument;

    /// csvファイルでデータの登録を行っている
    /// [num][lastName][firstName]の順番に登録していく。
    _storeButton() async {
      List<String> data;
      data = fileText.replaceAll('\n', ',').split(',');
      print(data);
      for (var i = 0; i < data.length; i += 3) {
        print('num ${data[i]}');
        print('lastName ${data[i + 1]}');
        print('firstName ${data[i + 2]}');
        try {
          final num = int.parse(data[i]);
          await classRoomProvider.registStudentData(
            args.homeRoom.id,
            num,
            data[i + 2],
            data[i + 1],
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

    _uploadFile() async {
      // ファイルの取得
      file = await FilePicker.getFile(
        type: FileType.custom,
//        fileExtension: 'csv',
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
          color: config.sd,
          textColor: Colors.white,
          child: const Text('ファイル選択・取り込み'),
          shape: const StadiumBorder(),
          onPressed: _uploadFile,
        ),
        Text(display),
        FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: const Text('保存'),
          onPressed: _storeButton,
        ),
      ],
    );
  }
}
