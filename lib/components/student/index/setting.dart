import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/homeroom.dart';
import 'package:lecture_performance_app/providers/student_index_provider.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

//routerで渡される値
class StudentSettingArgument {
  StudentSettingArgument(this.homeRoom);
  final HomeRoom homeRoom;
}

class StudentSetting extends StatelessWidget {
  static const routeName = '/student/setting';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as StudentSettingArgument;
    final student = initStudentAPI();
    final evaluation = initEvaluationAPI();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${args.homeRoom.grade}年${args.homeRoom.lectureClass}組',
        ),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: StudentIndexProvider(
              student: student,
              evaluation: evaluation,
              homeroomID: args.homeRoom.id,
            ),
          ),
        ],
        child: Consumer<StudentIndexProvider>(
          builder: (context, counter, _) {
            return ListView.builder(
              itemBuilder: (context, int index) {
                return Center(
                  child: Container(
                    width: 800,
                    child: const Center(child: _ListCard('データのインポート')),
                  ),
                );
              },
              itemCount: 1,
            );
          },
        ),
      ),
    );
  }
}

@immutable
class _ListCard extends StatelessWidget {
  const _ListCard(
    this.text,
  );
  final String text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        outButton();
        getFilePath().then(print);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: const IconButton(
              icon: Icon(
                Icons.download_rounded,
                color: Colors.blue,
                size: 40,
              ),
            ),
            title: Text(
              text,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void outButton() {
  getFilePath().then((File file) {
    file.writeAsString('ありがとうございました');
  });
}

//
Future<File> getFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  if (directory == null) {
    return null;
  }
  return File('${directory.path}/sample.txt');
}

Future load() async {
  final file = await getFilePath();
  return file;
}
