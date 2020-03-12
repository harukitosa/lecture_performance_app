import 'package:lecture_performance_app/repositories/semester.dart';
import 'package:lecture_performance_app/services/semester.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:lecture_performance_app/services/HomeRoom.dart';
void testsemesterService() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
  Database db = await initDB();
  var semesterRepository = new SemesterRepository(db: db);
  var semesterService = new SemesterService(semesterRepository: semesterRepository);
  var homeRoomRepository = new HomeRoomRepository(db: db);
  var homeRoomService = new HomeRoomService(homeRoomRepository: homeRoomRepository);
  test('SERVICE:SEMESTER',() async {
    var homeRoomID = await homeRoomService.createHomeRoom(2, 2);
    semesterService.createsemester('春学期', homeRoomID);
    var semesterList = await semesterService.getAllsemester();
    expect(semesterList[0].title, '春学期');
    expect(semesterList[0].homeRoomID, homeRoomID);
    semesterService.editsemester(semesterList[0].id, homeRoomID, '秋学期', semesterList[0].createTime);
    var updateList = await semesterService.getAllsemester();
    expect(updateList[0].title, '秋学期');
    await semesterService.deletesemester(semesterList[0].id);
    var deleteList = await semesterService.getAllsemester();
    expect(deleteList.length, 0);
  });
}