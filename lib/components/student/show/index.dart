import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/student/update/index.dart';
import 'package:lecture_performance_app/db/models/evaluation.dart';
import 'package:lecture_performance_app/db/models/homeroom.dart';
import 'package:lecture_performance_app/db/models/student.dart';
import 'package:lecture_performance_app/providers/student_show_provider.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:provider/provider.dart';

//routerで渡される値
class StudentShowArgument {
  StudentShowArgument(this.homeRoom, this.studentID);
  final HomeRoom homeRoom;
  final int studentID;
}

class StudentShow extends StatelessWidget {
  static const routeName = '/admin/student';
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as StudentShowArgument;
    final student = initStudentAPI();
    final evaluation = initEvaluationAPI();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: StudentShowProvider(
            student: student,
            evaluation: evaluation,
            studentID: args.studentID,
          ),
        ),
      ],
      child: Consumer<StudentShowProvider>(
        builder: (context, counter, _) {
          return StudentShowBody(args: args);
        },
      ),
    );
  }
}

class StudentShowBody extends StatelessWidget {
  const StudentShowBody({
    Key key,
    @required this.args,
  }) : super(key: key);

  final StudentShowArgument args;

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentShowProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${args.homeRoom.grade}年 ${args.homeRoom.lectureClass}組 生徒情報'),
      ),
      body: Center(
        child: AdminStudentView(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            StudentUpdate.routeName,
            arguments: StudentUpdateArgument(studentID: args.studentID),
          ).then((value) {
            student.update();
          });
        },
        tooltip: '生徒情報変更',
        label: const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            '生徒情報変更',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

class AdminStudentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _StudentEvaluationList(),
        ),
      ],
    );
  }
}

class _StudentEvaluationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentShowProvider>(context);
    return Container(
      child: (student.value != null)
          ? ScoreList(student: student.value, list: student.latestEvaluation)
          : Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                ],
              ),
            ),
    );
  }
}

class ScoreList extends StatelessWidget {
  const ScoreList({
    @required this.student,
    @required this.list,
  });

  final Student student;
  final List<Evaluation> list;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '名前:${student.lastName} ${student.firstName}',
                style: const TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '出席番号: ${student.number}',
                style: const TextStyle(
                  fontSize: 32,
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            '最新の評価',
            style: TextStyle(
              fontSize: 32,
            ),
          ),
        ),
        DataTable(
          columns: const [
            DataColumn(
              label: Text(
                'point',
                style: TextStyle(fontSize: 24),
              ),
            ),
            DataColumn(
              label: Text(
                '記録日',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
          rows: list
              .map(
                (item) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        item.point.toString(),
                        style: const TextStyle(fontSize: 22),
                      ),
                      onTap: () {},
                    ),
                    DataCell(
                      Text(
                        item.createTime,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
