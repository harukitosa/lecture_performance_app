
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:lecture_performance_app/services/HomeRoom.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

void testHomeRoomService() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
  Database db = await initDB();
  var homeRoomRepository = new HomeRoomRepository(db: db);
  var homeRoomService = new HomeRoomService(homeRoomRepository: homeRoomRepository);
  test('SERVICE:HOMEROOM',() async {
    homeRoomService.createHomeRoom(2, 2);
    var homeRoomList = await homeRoomService.getAllHomeRoom();
    expect(homeRoomList[0].grade, 2);
    expect(homeRoomList[0].lectureClass, 2);
    homeRoomService.editHomeRoom(homeRoomList[0].id, 3, 14, homeRoomList[0].createTime);
    var updateList = await homeRoomService.getAllHomeRoom();
    expect(updateList[0].grade, 3);
    expect(updateList[0].lectureClass, 14);
    await homeRoomService.deleteHomeRoom(homeRoomList[0].id);
    var deleteList = await homeRoomService.getAllHomeRoom();
    expect(deleteList.length, 0);
  });
}