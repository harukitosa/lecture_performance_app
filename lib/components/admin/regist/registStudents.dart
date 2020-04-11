import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/popup/comfirmPopup.dart';
import 'package:lecture_performance_app/components/admin/classroom/index.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
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
  String display = "";
  String fileText = "";
  File file;
  int id;
  var config = AppStyle();

  @override
  Widget build(BuildContext context) {
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    final RegistStudentsArgument args =
        ModalRoute.of(context).settings.arguments;

    _storeButton() async {
      List data = fileText.replaceAll('\n', ',').split(',');
      print(data);
      for (var i = 0; i < data.length; i += 3) {
        print("num" + data[i]);
        print("lastName" + data[i + 1]);
        print("firstName" + data[i + 2]);
        try {
          var num = int.parse(data[i]);
          await classRoomProvider.registStudentData(
            args.homeRoom.id,
            num,
            data[i + 2],
            data[i + 1],
          );
        } catch (exception) {}
      }
      confirmPopUp(context, AdminClassRoom.routeName);
      setState(() {
        display = "";
      });
    }

    _uploadFile() async {
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
            child: Text("ファイル選択・取り込み"),
            shape: StadiumBorder(),
            onPressed: _uploadFile,
          ),
          Text(display),
          FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text("保存"),
            onPressed: _storeButton,
          ),
        ]);
  }
}
