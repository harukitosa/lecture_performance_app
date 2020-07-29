import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/student/update/index.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/db/models/evaluation.dart';
import 'package:lecture_performance_app/db/models/student.dart';
import 'package:lecture_performance_app/providers/evaluation_provider.dart';
import 'package:lecture_performance_app/providers/student_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${args.homeRoom.grade}年 ${args.homeRoom.lectureClass}組 生徒情報'),
      ),
      body: Consumer<StudentProvider>(
        builder: (context, counter, _) {
          return Consumer<EvaluationProvider>(
            builder: (context, counter, _) {
              return Center(
                child: AdminStudentView(),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            StudentUpdate.routeName,
            arguments: StudentUpdateArgument(studentID: args.studentID),
          ).then((value) {
            print('hallowed');
          });
        },
        tooltip: 'Increment',
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
    final args =
        ModalRoute.of(context).settings.arguments as StudentShowArgument;
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: StudentEvaluationList(
            studentID: args.studentID,
          ),
        ),
      ],
    );
  }
}

class StudentEvaluationList extends StatefulWidget {
  const StudentEvaluationList({this.studentID});
  final int studentID;
  @override
  _StudentEvaluationListState createState() => _StudentEvaluationListState();
}

class _StudentEvaluationListState extends State<StudentEvaluationList> {
  final _evaluationAPI = initEvaluationAPI();
  final _studentAPI = initStudentAPI();
  List<Evaluation> _list = [];
  Student _student;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: (_student != null)
          ? ScoreList(student: _student, list: _list)
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

  @override
  void initState() {
    super.initState();
    _evaluationAPI.getLatestStudent(widget.studentID).then((value) {
      setState(() {
        _list = value;
      });
    });
    _studentAPI.getStudent(widget.studentID).then((value) {
      setState(() {
        _student = value;
      });
    });
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

//class AdminLatestEvaluationInfo extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final args =
//        ModalRoute.of(context).settings.arguments as StudentShowArgument;
//    final sp = Provider.of<StudentProvider>(context);
//    final e = Provider.of<EvaluationProvider>(context);
//    final s = sp.getStudent(args.studentID);
//    final lastName = s.student?.lastName ?? '';
//    final firstName = s.student?.firstName ?? '';
//    final number = s.student?.number ?? 0;
//    return ListView(
//      children: <Widget>[
//        Row(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(8),
//              child: Text(
//                s.student != null ? '名前:$lastName $firstName' : 'NOT NAME',
//                style: const TextStyle(
//                  fontSize: 28,
//                ),
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(8),
//              child: Text(
//                s.student != null ? '出席番号: $number' : 'NOT NUMBER',
//                style: const TextStyle(
//                  fontSize: 32,
//                ),
//              ),
//            ),
//          ],
//        ),
//        const Padding(
//          padding: EdgeInsets.all(8),
//          child: Text(
//            '最新の評価',
//            style: TextStyle(
//              fontSize: 32,
//            ),
//          ),
//        ),
//        DataTable(
//          columns: const [
//            DataColumn(
//              label: Text(
//                'point',
//                style: TextStyle(fontSize: 24),
//              ),
//            ),
//            DataColumn(
//              label: Text(
//                '記録日',
//                style: TextStyle(fontSize: 24),
//              ),
//            ),
//          ],
//          rows: e.list.isNotEmpty
//              ? e
//                  .list
//                  .map(
//                    (item) => DataRow(
//                      cells: [
//                        DataCell(
//                          Text(
//                            item.point.toString(),
//                            style: const TextStyle(fontSize: 22),
//                          ),
//                          onTap: () {},
//                        ),
//                        DataCell(
//                          Text(
//                            item.createTime,
//                            style: const TextStyle(fontSize: 22),
//                          ),
//                        ),
//                      ],
//                    ),
//                  )
//                  .toList()
//              : [
//                  const DataRow(
//                    cells: [
//                      DataCell(
//                        Text('NO DATA'),
//                      ),
//                      DataCell(
//                        Text('NO DATA'),
//                      ),
//                      DataCell(
//                        Text('NO DATA'),
//                      )
//                    ],
//                  ),
//                  const DataRow(
//                    cells: [
//                      DataCell(
//                        Text('NO DATA'),
//                      ),
//                      DataCell(
//                        Text('NO DATA'),
//                      ),
//                      DataCell(
//                        Text('NO DATA'),
//                      )
//                    ],
//                  ),
//                ],
//        ),
//      ],
//    );
//  }
//}
