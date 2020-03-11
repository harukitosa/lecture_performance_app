import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:lecture_performance_app/db/models/User.dart';
import 'package:lecture_performance_app/repositories/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void testHomeRoomRepository() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
    Database db = await initDB();
    var homeRoomRepository = new HomeRoomRepository(db: db);
    var userRepository = new UserRepository(db: db);
  test("REPOSITORY:INSERT HOMEROOM", () async {
      var user = new User(name: "test", password: "testtest", email: "sample@mail.com");
      await userRepository.insertUser(user);
      var users = await userRepository.getAllUsers();
      var homeRoom = new HomeRoom(userID: users[0].id, grade: 1, lectureClass: 2);
      homeRoomRepository.insertHomeRoom(homeRoom);
      var homerooms = await homeRoomRepository.getHomeRooms(1);
      expect(homerooms[0].userID, users[0].id);
      expect(homerooms[0].grade, 1);
      expect(homerooms[0].lectureClass, 2);
      homeRoomRepository.deleteHomeRoom(homerooms[0].id);
  });

  test("REPOSITORY:DELETE HOMEROOM", () async {
      var user = new User(name: "test", password: "testtest", email: "sample@mail.com");
      await userRepository.insertUser(user);
      var users = await userRepository.getAllUsers();
      var homeRoom = new HomeRoom(userID: users[0].id, grade: 1, lectureClass: 2);
      await homeRoomRepository.insertHomeRoom(homeRoom);
      List<HomeRoom> homerooms = await homeRoomRepository.getHomeRooms(users[0].id);
      for(int i = 0;i < homerooms.length;i++) {
        homeRoomRepository.deleteHomeRoom(users[i].id);
      }
      List<HomeRoom> lastHomeRooms = await homeRoomRepository.getHomeRooms(users[0].id);
      expect(lastHomeRooms.length, 0);
  });

  test("REPOSITORY:UPDATE HOMEROOM", () async {
      var user = new User(name: "test", password: "testtest", email: "sample@mail.com");
      await userRepository.insertUser(user);
      var users = await userRepository.getAllUsers();
      var homeRoom = new HomeRoom(userID: users[0].id, grade: 1, lectureClass: 2);
      await homeRoomRepository.insertHomeRoom(homeRoom);
      List<HomeRoom> res = await homeRoomRepository.getHomeRooms(users[0].id);
      var update = new HomeRoom(id: res[0].id,userID: res[0].userID, grade: 2, lectureClass: 3, createTime: res[0].createTime, updateTime: res[0].updateTime);
      await homeRoomRepository.updateHomeRoom(update);
      List<HomeRoom> response = await homeRoomRepository.getHomeRooms(users[0].id);
      expect(response[0].userID, users[0].id);
      expect(response[0].grade, 2);
      expect(response[0].lectureClass, 3);
  });
}