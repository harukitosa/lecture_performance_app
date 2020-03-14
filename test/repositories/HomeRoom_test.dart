import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void testHomeRoomRepository() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
    Database db = await initDB();
    var homeRoomRepository = new HomeRoomRepository(db: db);
  test("REPOSITORY:INSERT HOMEROOM", () async {
      var homeRoom = new HomeRoom(grade: 1, lectureClass: 2);
      homeRoomRepository.insertHomeRoom(homeRoom);
      var homerooms = await homeRoomRepository.getHomeRooms();
      //初期代入データがあるため。
      expect(homerooms[1].grade, 1);
      expect(homerooms[1].lectureClass, 2);
      homeRoomRepository.deleteHomeRoom(homerooms[1].id);
  });

  test("REPOSITORY:DELETE HOMEROOM", () async {
      var homeRoom = new HomeRoom(grade: 1, lectureClass: 2);
      await homeRoomRepository.insertHomeRoom(homeRoom);
      List<HomeRoom> homerooms = await homeRoomRepository.getHomeRooms();
      for(int i = 0;i < homerooms.length;i++) {
        homeRoomRepository.deleteHomeRoom(homerooms[i].id);
      }
      List<HomeRoom> lastHomeRooms = await homeRoomRepository.getHomeRooms();
      expect(lastHomeRooms.length, 0);
  });

  test("REPOSITORY:UPDATE HOMEROOM", () async {
      var homeRoom = new HomeRoom(grade: 1, lectureClass: 2);
      await homeRoomRepository.insertHomeRoom(homeRoom);
      List<HomeRoom> res = await homeRoomRepository.getHomeRooms();
      var update = new HomeRoom(id: res[0].id, grade: 2, lectureClass: 3, createTime: res[0].createTime, updateTime: res[0].updateTime);
      await homeRoomRepository.updateHomeRoom(update);
      List<HomeRoom> response = await homeRoomRepository.getHomeRooms();
      expect(response[0].grade, 2);
      expect(response[0].lectureClass, 3);
  });
}