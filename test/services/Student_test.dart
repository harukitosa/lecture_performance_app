import 'package:lecture_performance_app/repositories/Student.dart';
import 'package:lecture_performance_app/services/Student.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:lecture_performance_app/services/HomeRoom.dart';
void teststudentService() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
  Database db = await initDB();
  var studentRepository = new StudentRepository(db: db);
  var studentService = new StudentService(studentRepository: studentRepository);
  var homeRoomRepository = new HomeRoomRepository(db: db);
  var homeRoomService = new HomeRoomService(homeRoomRepository: homeRoomRepository);
  test('SERVICE:STUDENT',() async {
    var homeRoomID = await homeRoomService.createHomeRoom(2, 2);
    await studentService.createstudent(homeRoomID, "sample");
    var studentList = await studentService.getRoomStudents(homeRoomID);
    expect(studentList[0].name, 'sample');
    expect(studentList[0].homeRoomID, homeRoomID);
    await studentService.editstudent(studentList[0].id, homeRoomID, 2, 'サンプル', studentList[0].createTime);
    var updateList = await studentService.getRoomStudents(homeRoomID);
    expect(updateList[0].name, 'サンプル');
    await studentService.deletestudent(studentList[0].id);
    var deleteList = await studentService.getRoomStudents(homeRoomID);
    expect(deleteList.length, 0);
  });
}