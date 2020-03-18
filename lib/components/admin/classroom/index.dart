import 'package:flutter/material.dart';
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
            return Center(
              child: StudentTable(studentList: classRoomProvider.studentList),
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
        backgroundColor: Colors.red,
      ),
    );
  }
}

class StudentTable extends StatelessWidget {
  final List<Student> studentList;
  StudentTable({this.studentList});
  @override
  Widget build(BuildContext context) {
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
              'RollNo',
              style: TextStyle(fontSize: 24),
            )),
            DataColumn(
                label: Text(
              'Name',
              style: TextStyle(fontSize: 24),
            )),
            DataColumn(
                label: Text(
              'POINTS',
              style: TextStyle(fontSize: 24),
            )),
          ],
          rows: studentList
              .map(
                (student) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        student.id.toString(),
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    DataCell(
                      Text(
                        student.name,
                        style: TextStyle(fontSize: 22),
                      ),
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
              .toList(),
        ),
      ],
    );
  }
}
