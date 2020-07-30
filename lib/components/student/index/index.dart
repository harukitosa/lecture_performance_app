import 'package:flutter/material.dart';
import 'package:lecture_performance_app/components/homeroom/delete/index.dart';
import 'package:lecture_performance_app/components/seat/update/update_position.dart';
import 'package:lecture_performance_app/components/seat/update/update_used.dart';
import 'package:lecture_performance_app/components/student/create/index.dart';
import 'package:lecture_performance_app/components/student/show/index.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/providers/student_index_provider.dart';
import 'package:lecture_performance_app/providers/student_provider.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:provider/provider.dart';

//routerで渡される値
class StudentIndexArgument {
  StudentIndexArgument(this.homeRoom);
  final HomeRoom homeRoom;
}

class StudentIndex extends StatelessWidget {
  static const routeName = '/admin/homeroom';
  final AppStyle config = AppStyle();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as StudentIndexArgument;
    final student = initStudentAPI();
    final evaluation = initEvaluationAPI();
    return MultiProvider(
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
          return StudentIndexBody(args: args, config: config);
        },
      ),
    );
  }
}

class StudentIndexBody extends StatelessWidget {
  const StudentIndexBody({
    Key key,
    @required this.args,
    @required this.config,
  }) : super(key: key);

  final StudentIndexArgument args;
  final AppStyle config;

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.settings),
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
      body: Consumer<StudentProvider>(
        builder: (context, counter, _) {
          return AdminStudentListView();
        },
      ),
      floatingActionButton: BtnColumn(config: config, args: args),
    );
  }
}

class BtnColumn extends StatelessWidget {
  const BtnColumn({
    Key key,
    @required this.config,
    @required this.args,
  }) : super(key: key);

  final AppStyle config;
  final StudentIndexArgument args;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _FloatBtn(
          config: config,
          routeName: StudentCreate.routeName,
          argument: StudentCreateArgument(
            args.homeRoom,
          ),
          title: '生徒追加',
          color: config.sl,
          heroName: 'studentCreate',
        ),
        _FloatBtn(
          config: config,
          routeName: SeatUpdateUsed.routeName,
          argument: SeatUpdateUsedArgument(args.homeRoom),
          title: '座席位置変更',
          heroName: 'updateSeatPosition',
          color: config.s,
        ),
        _FloatBtn(
          config: config,
          routeName: SeatUpdatePosition.routeName,
          argument: SeatUpdatePositionArgument(args.homeRoom),
          title: '席替え',
          color: config.sd,
          heroName: 'seatUpdate',
        )
      ],
    );
  }
}

class _FloatBtn extends StatelessWidget {
  const _FloatBtn({
    Key key,
    @required this.config,
    @required this.routeName,
    @required this.argument,
    @required this.title,
    @required this.color,
    @required this.heroName,
  }) : super(key: key);

  final AppStyle config;
  final String routeName;
  final dynamic argument;
  final String title;
  final Color color;
  final String heroName;

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentIndexProvider>(context);
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
              fontSize: config.size4,
              color: config.st,
            ),
          ),
        ),
        backgroundColor: color,
        onPressed: () {
          Navigator.pushNamed(
            context,
            routeName,
            arguments: argument,
          ).then((value) {
            student.updateList();
          });
        },
      ),
    );
  }
}

class AdminStudentListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        Expanded(
          flex: 2,
          child: Center(
            child: StudentTable(),
          ),
        ),
      ],
    );
  }
}

class StudentTable extends StatelessWidget {
  const StudentTable();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as StudentIndexArgument;
    final student = Provider.of<StudentIndexProvider>(context);
    return ListView(
      children: <Widget>[
        DataTable(
          sortColumnIndex: 0,
          columns: const [
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
          rows: student.list
              .map(
                (item) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        item.student.number.toString(),
                        style: const TextStyle(fontSize: 22),
                      ),
                      onTap: () {},
                    ),
                    DataCell(
                      Text(
                        '${item.student.lastName} '
                        '${item.student.firstName}',
                        style: const TextStyle(fontSize: 22),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          StudentShow.routeName,
                          arguments: StudentShowArgument(
                            args.homeRoom,
                            item.student.id,
                          ),
                        );
                      },
                    ),
                    DataCell(
                      Text(
                        item.score.toString(),
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
