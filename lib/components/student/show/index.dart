import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/student/update/index.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/student_before_provider.dart';
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
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: StudentBeforeProvider(args.studentID),
          ),
        ],
        child: Consumer<StudentBeforeProvider>(
          builder: (context, counter, _) {
            return Center(
              child: AdminStudentView(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            StudentUpdate.routeName,
            arguments: StudentUpdateArgument(studentID: args.studentID),
          );
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
    return Row(
      children: <Widget>[
        Expanded(
          flex: 500,
          child: AdminLatestEvaluationInfo(),
        ),
        Expanded(
          flex: 1,
          child: Container(
            width: 1,
            color: Colors.blueAccent,
          ),
        ),
        Expanded(
          flex: 500,
          child: AdminEvaluationInfo(),
        ),
      ],
    );
  }
}

class AdminLatestEvaluationInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as StudentShowArgument;
    final studentProvider = Provider.of<StudentBeforeProvider>(context);
    final lastName =
        studentProvider.student != null ? studentProvider.student.lastName : '';
    final firstName = studentProvider.student != null
        ? studentProvider.student.firstName
        : '';
    return ListView(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                studentProvider.student != null
                    ? '名前:$lastName $firstName'
                    : 'NOT NAME',
                style: const TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                studentProvider.student != null
                    ? '出席番号: ${studentProvider.student.number}'
                    : 'NOT NUMBER',
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
                'type',
                style: TextStyle(fontSize: 24),
              ),
            ),
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
          rows: studentProvider.latest != null
              ? studentProvider.latest
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            item.title != null ? item.title : '',
                            style: const TextStyle(fontSize: 22),
                          ),
                          onTap: () {},
                        ),
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
                  .toList()
              : [
                  const DataRow(
                    cells: [
                      DataCell(
                        Text('NO DATA'),
                      ),
                      DataCell(
                        Text('NO DATA'),
                      ),
                      DataCell(
                        Text('NO DATA'),
                      )
                    ],
                  ),
                  const DataRow(
                    cells: [
                      DataCell(
                        Text('NO DATA'),
                      ),
                      DataCell(
                        Text('NO DATA'),
                      ),
                      DataCell(
                        Text('NO DATA'),
                      )
                    ],
                  ),
                ],
        ),
      ],
    );
  }
}

class AdminEvaluationInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentBeforeProvider>(context);
    return ListView(
      children: <Widget>[
        DataTable(
          columns: const [
            DataColumn(
              label: Text(
                'type',
                style: TextStyle(fontSize: 24),
              ),
            ),
            DataColumn(
              label: Text(
                'point',
                style: TextStyle(fontSize: 24),
              ),
            ),
            DataColumn(
              label: Text(
                '合計ポイント数',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
          rows: studentProvider.sumList != null
              ? studentProvider.sumList
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            item.id != null ? item.id.toString() : '',
                            style: const TextStyle(fontSize: 22),
                          ),
                          onTap: () {},
                        ),
                        DataCell(
                          Text(
                            item.title,
                            style: const TextStyle(fontSize: 22),
                          ),
                          onTap: () {},
                        ),
                        DataCell(
                          Text(
                            item.point.toString(),
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList()
              : const [
                  DataRow(
                    cells: [
                      DataCell(
                        Text('NO DATA'),
                      ),
                      DataCell(
                        Text('NO DATA'),
                      ),
                      DataCell(
                        Text('NO DATA'),
                      )
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Text('NO DATA'),
                      ),
                      DataCell(
                        Text('NO DATA'),
                      ),
                      DataCell(
                        Text('NO DATA'),
                      )
                    ],
                  ),
                ],
        ),
      ],
    );
  }
}
