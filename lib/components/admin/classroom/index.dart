import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/admin/classroom/seatArrange.dart';
import 'package:lecture_performance_app/components/admin/classroom/studentDetail.dart';
import 'package:lecture_performance_app/components/admin/edit/editSeat.dart';
import 'package:lecture_performance_app/components/admin/edit/deleteClassroom.dart';
import 'package:lecture_performance_app/components/admin/regist/registStudent.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/db/models/Student.dart';
import 'package:provider/provider.dart';
import 'package:lecture_performance_app/providers/ClassRoomProvider.dart';

//routerで渡される値
class AdminClassRoomArgument {
  AdminClassRoomArgument(this.homeRoom);
  final HomeRoom homeRoom;
}

class AdminClassRoom extends StatelessWidget {
  static const routeName = '/admin/homeroom';
  final AppStyle config = AppStyle();
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as AdminClassRoomArgument;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${args.homeRoom.grade}年 ${args.homeRoom.lectureClass}組 管理画面',
          style: TextStyle(
            fontSize: config.size4,
            color: config.st,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(
                context,
                DeleteClassRoom.routeName,
                arguments: DeleteClassRoomArguments(args.homeRoom),
              );
            },
          ),
        ],
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: ClassRoomProvider(args.homeRoom.id),
          ),
        ],
        child: Consumer<ClassRoomProvider>(
          builder: (context, counter, _) {
            return AdminStudentListView();
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _FloatingButton(
            route: () {
              Navigator.pushNamed(
                context,
                RegistStudent.routeName,
                arguments: RegistStudentArgument(
                  args.homeRoom,
                ),
              );
            },
            title: '生徒追加',
            heroName: 'student',
            fontSize: config.size4,
            textColor: config.st,
            backColor: config.sl,
          ),
          _FloatingButton(
            route: () {
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
            title: '座席位置変更',
            heroName: 'seat',
            fontSize: config.size4,
            textColor: config.st,
            backColor: config.s,
          ),
          _FloatingButton(
            route: () {
              Navigator.pushNamed(
                context,
                SeatArrange.routeName,
                arguments: SeatArrangeArgument(
                  args.homeRoom,
                ),
              );
            },
            title: '席替え',
            heroName: 'changeSeat',
            fontSize: config.size4,
            textColor: config.st,
            backColor: config.sd,
          )
        ],
      ),
    );
  }
}

class _FloatingButton extends StatelessWidget {
  const _FloatingButton({
    Key key,
    @required this.route,
    @required this.title,
    @required this.heroName,
    @required this.fontSize,
    @required this.textColor,
    @required this.backColor,
  }) : super(key: key);

  final VoidCallback route;
  final String title;
  final String heroName;
  final double fontSize;
  final Color textColor;
  final Color backColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      width: 200,
      child: FloatingActionButton.extended(
        tooltip: title,
        heroTag: heroName,
        label: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
            ),
          ),
        ),
        backgroundColor: backColor,
        onPressed: route,
      ),
    );
  }
}

class AdminStudentListView extends StatelessWidget {
  // final AdminClassRoomArgument args =
  //     ModalRoute.of(context).settings.arguments;
  // classRoomProvider.getStudentData(args.homeRoom.id);
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

class StudentTable extends StatelessWidget {
  const StudentTable({this.studentList});

  final List<Student> studentList;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as AdminClassRoomArgument;
    final classRoomProvider = Provider.of<ClassRoomProvider>(context);
    return ListView(
      children: <Widget>[
        DataTable(
          sortAscending: classRoomProvider.sort,
          sortColumnIndex: 0,
          columns: [
            DataColumn(
              onSort: (columnIndex, ascending) {
                classRoomProvider
                  ..sortChange()
                  ..onSortColum(columnIndex, ascending);
              },
              label: const Text(
                '出席番号',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const DataColumn(
              label: Text(
                '名前',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const DataColumn(
              label: Text(
                'POINTS',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
          rows: (studentList != null)
              ? studentList
                  .map(
                    (student) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            student.number.toString(),
                            style: const TextStyle(fontSize: 22),
                          ),
                          onTap: () {},
                        ),
                        DataCell(
                          Text(
                            '${student.lastName} ${student.firstName}',
                            style: const TextStyle(fontSize: 22),
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
                            student.evaluationSum.toString(),
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
                      ),
                    ],
                  ),
                ],
        ),
      ],
    );
  }
}
