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
      userRepository.insertUser(user);
      var users = await userRepository.getAllUsers();
      var homeRoom = new HomeRoom(userID: users[0].id, grade: 1, lectureClass: 2);
      homeRoomRepository.insertHomeRoom(homeRoom);
      var homerooms = await homeRoomRepository.getHomeRoom(1);
      expect(homerooms[0].userID, users[0].id);
      expect(homerooms[0].grade, 1);
      expect(homerooms[0].lectureClass, 2);
      homeRoomRepository.deleteHomeRooms(homerooms[0].id);
  });
}