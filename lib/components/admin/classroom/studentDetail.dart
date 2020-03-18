import 'package:flutter/material.dart';
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
        onPressed: () {},
        tooltip: 'Increment',
        label: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            '管理画面',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class AdminStudentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdminEvaluationInfo();
  }
}

class AdminStudentInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    return Column(
      children: <Widget>[
        Text(
          studentProvider.student != null
              ? '名前:' + studentProvider.student.name
              : "NOT NAME",
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        Text(
          studentProvider.student != null
              ? '出席番号:' + studentProvider.student.number.toString()
              : "NOT NUMBER",
          style: TextStyle(
            fontSize: 32,
          ),
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
        Text(
          studentProvider.student != null
              ? '名前:' + studentProvider.student.name
              : "NOT NAME",
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        Text(
          studentProvider.student != null
              ? '出席番号:' + studentProvider.student.number.toString()
              : "NOT NUMBER",
          style: TextStyle(
            fontSize: 32,
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
            rows: studentProvider.eval != null
                ? studentProvider.eval
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
                    DataRow(cells: [
                      DataCell(
                        Text('NO DATA'),
                      ),
                      DataCell(
                        Text('NO DATA'),
                      ),
                      DataCell(
                        Text('NO DATA'),
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                        Text('NO DATA'),
                      ),
                      DataCell(
                        Text('NO DATA'),
                      ),
                      DataCell(
                        Text('NO DATA'),
                      )
                    ]),
                  ]),
      ],
    );
  }
}
