import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/admin/classroom/seatArrange.dart';
import 'package:lecture_performance_app/components/admin/classroom/studentDetail.dart';
import 'package:lecture_performance_app/components/admin/edit/editSeat.dart';
import 'package:lecture_performance_app/components/admin/regist/registStudent.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
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
  final config = AppStyle();
  @override
  Widget build(BuildContext context) {
    final AdminClassRoomArgument args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.homeRoom.grade + "年" + args.homeRoom.lectureClass + "組 管理画面",
          style: TextStyle(
            fontSize: config.size4,
            color: config.st,
          ),
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
            return AdminStudentListView();
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
              fontSize: config.size4,
              color: config.st,
            ),
          ),
        ),
        backgroundColor: config.pd,
      ),
    );
  }
}

class AdminStudentListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Center(
            child: StudentTable(studentList: classRoomProvider.studentList),
          ),
        ),
      ],
    );
  }
}

class SettingButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AdminClassRoomArgument args =
        ModalRoute.of(context).settings.arguments;
    final common = AppStyle();

    return Container(
      child: Row(children: <Widget>[
        Expanded(
          child: Container(
            height: 100,
            width: 200,
            padding: EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text(
                "席替え",
                style: TextStyle(
                  color: common.st,
                  fontSize: common.size4,
                ),
              ),
              color: common.s,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  SeatArrange.routeName,
                  arguments: SeatArrangeArgument(
                    args.homeRoom,
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 100,
            width: 200,
            padding: EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text(
                "座席位置変更",
                style: TextStyle(
                  color: common.st,
                  fontSize: common.size4,
                ),
              ),
              color: common.sl,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  EditSeat.routeName,
                  arguments: EditSeatArgument(
                    args.homeRoom.grade,
                    args.homeRoom.lectureClass,
                    args.homeRoom.id,
                  ),
                );
              },
            ),
          ),
        ),
      ]),
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
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    return ListView(
      children: <Widget>[
        SettingButtons(),
        DataTable(
          sortAscending: classRoomProvider.sort,
          sortColumnIndex: 0,
          columns: [
            DataColumn(
              onSort: (columnIndex, ascending) {
                classRoomProvider.sortChange();
                classRoomProvider.onSortColum(columnIndex, ascending);
              },
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
                            student.lastName + " " + student.firstName,
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
