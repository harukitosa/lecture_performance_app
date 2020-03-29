import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/admin/edit/editStudent.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/StudentProvider.dart';
import 'package:provider/provider.dart';

//routerで渡される値
class AdminStudentDetailArgument {
  final HomeRoom homeRoom;
  final int studentID;
  AdminStudentDetailArgument(this.homeRoom, this.studentID);
}

class AdminStudentDetail extends StatelessWidget {
  static const routeName = '/admin/student';
  @override
  Widget build(BuildContext context) {
    final AdminStudentDetailArgument args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            args.homeRoom.grade + "年" + args.homeRoom.lectureClass + "組 生徒情報"),
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
              child: AdminStudentView(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            EditStudent.routeName,
            arguments: EditStudentArgument(studentID: args.studentID),
          );
        },
        tooltip: 'Increment',
        label: Padding(
          padding: EdgeInsets.all(12.0),
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
    final AdminStudentDetailArgument args =
        ModalRoute.of(context).settings.arguments;
    final studentProvider = Provider.of<StudentProvider>(context);
    studentProvider.getStudent(args.studentID);
    return ListView(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                studentProvider.student != null
                    ? '名前:' +
                        studentProvider.student.lastName +
                        " " +
                        studentProvider.student.firstName
                    : "NOT NAME",
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                studentProvider.student != null
                    ? '出席番号:' + studentProvider.student.number.toString()
                    : "NOT NUMBER",
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "最新の評価",
            style: TextStyle(
              fontSize: 32,
            ),
          ),
        ),
        DataTable(
          columns: [
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
                            item.title != null ? item.title : "",
                            style: TextStyle(fontSize: 22),
                          ),
                          onTap: () {},
                        ),
                        DataCell(
                          Text(
                            item.point.toString(),
                            style: TextStyle(fontSize: 22),
                          ),
                          onTap: () {},
                        ),
                        DataCell(
                          Text(
                            item.createTime,
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList()
              : [
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

class AdminEvaluationInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    return ListView(
      children: <Widget>[
        DataTable(
          columns: [
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
                            item.id != null ? item.id.toString() : "",
                            style: TextStyle(fontSize: 22),
                          ),
                          onTap: () {},
                        ),
                        DataCell(
                          Text(
                            item.title,
                            style: TextStyle(fontSize: 22),
                          ),
                          onTap: () {},
                        ),
                        DataCell(
                          Text(
                            item.point.toString(),
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList()
              : [
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
