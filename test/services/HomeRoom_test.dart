
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:lecture_performance_app/services/HomeRoom.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_test/flutter_test.dart';

void testHomeRoomService() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
  var homeRoomRepository = new HomeRoomRepository();
  var homeRoomService = new HomeRoomService(homeRoomRepository: homeRoomRepository);
  test('SERVICE:HOMEROOM',() async {
    homeRoomService.createHomeRoom("2", "2");
    var homeRoomList = await homeRoomService.getAllHomeRoom();
    //初期データが存在するため。
    expect(homeRoomList[1].grade, "2");
    expect(homeRoomList[1].lectureClass, "2");
    homeRoomService.editHomeRoom(homeRoomList[0].id, "3", "14", homeRoomList[0].createTime);
    var updateList = await homeRoomService.getAllHomeRoom();
    expect(updateList[0].grade, "3");
    expect(updateList[0].lectureClass, "14");
    await homeRoomService.deleteHomeRoom(homeRoomList[0].id);
    var deleteList = await homeRoomService.getAllHomeRoom();
    //初期データが存在するため
    expect(deleteList.length, 1);
  });
}