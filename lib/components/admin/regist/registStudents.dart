import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/popup/comfirmPopup.dart';
import 'package:lecture_performance_app/components/admin/classroom/index.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart';

//routerで渡される値
class RegistStudentsArgument {
  final HomeRoom homeRoom;
  RegistStudentsArgument(this.homeRoom);
}

class RegistStudents extends StatelessWidget {
  static const routeName = '/admin/regist/students';
  @override
  Widget build(BuildContext context) {
    final RegistStudentsArgument args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.homeRoom.grade + "年" + args.homeRoom.lectureClass + "組 まとめて登録",
        ),
        actions: <Widget>[],
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ClassRoomProvider(args.homeRoom.id),
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
  String display = "";
  String fileText = "";
  File file;
  int id;
  @override
  Widget build(BuildContext context) {
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    final RegistStudentsArgument args =
        ModalRoute.of(context).settings.arguments;
    return Column(children: <Widget>[
      Container(
        child: Column(
          children: <Widget>[
            Text(
              '.csv形式のファイルを選択してください。',
              style: TextStyle(fontSize: 32),
            ),
            Text(
              '一行目に名前、二行目に出席番号を記入してください。',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
      FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: Text("ファイル選択・取り込み"),
        onPressed: () async {
          // ファイルの取得
          file = await FilePicker.getFile(
            type: FileType.custom,
            fileExtension: 'csv',
          );
          // ファイルの中身を取得
          if (file != null) {
            fileText = await file.readAsString();
          }
          // 画面に表示
          setState(() {
            display = basename(file.path);
          });
        },
      ),
      Text(display),
      FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: Text("保存"),
        onPressed: () async {
          List data = fileText.replaceAll('\n', ',').split(',');
          print(data);
          for (var i = 0; i < data.length; i += 2) {
            // print("name" + data[i]);
            // print("num" + data[i + 1]);
            try {
              var num = int.parse(data[i + 1]);
              await classRoomProvider.registStudentData(
                args.homeRoom.id,
                num,
                data[i],
              );
            } catch (exception) {}
          }
          confirmPopUp(context, AdminClassRoom.routeName);
          setState(() {
            display = "";
          });
        },
      ),
    ]);
  }
}
