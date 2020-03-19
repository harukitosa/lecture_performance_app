import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/admin/classroom/studentDetail.dart';
import 'package:lecture_performance_app/components/admin/regist/registStudent.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/db/models/Student.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';

//routerで渡される値
class AdminClassRoomArgument {
  final HomeRoom homeRoom;
  AdminClassRoomArgument(this.homeRoom);
}

class AdminClassRoom extends StatelessWidget {
  static const routeName = '/admin/homeroom';
  @override
  Widget build(BuildContext context) {
    final AdminClassRoomArgument args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.homeRoom.grade + "年" + args.homeRoom.lectureClass + "組 管理画面",
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
            final classRoomProvider = Provider.of<ClassRoomProvider>(context);
            classRoomProvider.getStudentData(args.homeRoom.id);
            return Center(
              child: StudentTable(studentList: classRoomProvider.studentList),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            RegistStudent.routeName,
            arguments: RegistStudentArgument(
              args.homeRoom,
            ),
          );
        },
        tooltip: 'Increment',
        label: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            '生徒追加',
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


class StudentTable extends StatelessWidget {
  final List<Student> studentList;

  StudentTable({this.studentList});

  @override
  Widget build(BuildContext context) {
    final AdminClassRoomArgument args =
        ModalRoute.of(context).settings.arguments;

    return ListView(
      children: <Widget>[
        Center(
            child: Text(
          '生徒名簿',
          style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
        )),
        DataTable(
          columns: [
            DataColumn(
              label: Text(
                '出席番号',
                style: TextStyle(fontSize: 24),
              ),
            ),
            DataColumn(
              label: Text(
                '名前',
                style: TextStyle(fontSize: 24),
              ),
            ),
            DataColumn(
              label: Text(
                'POINTS',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
          rows: studentList != null
              ? studentList
                  .map(
                    (student) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            student.number.toString(),
                            style: TextStyle(fontSize: 22),
                          ),
                          onTap: () {},
                        ),
                        DataCell(
                          Text(
                            student.name,
                            style: TextStyle(fontSize: 22),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AdminStudentDetail.routeName,
                              arguments: AdminStudentDetailArgument(
                                args.homeRoom,
                                student.id,
                              ),
                            );
                          },
                        ),
                        DataCell(
                          Text(
                            student.createTime,
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
                      ),
                    ],
                  ),
                ],
        ),
      ],
    );
  }
}
