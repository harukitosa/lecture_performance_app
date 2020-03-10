import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:lecture_performance_app/db/models/User.dart';
import 'package:lecture_performance_app/repositories/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
  Database db = await initDB();
  var userRepository = new UserRepository(db: db);
  
  test("REPOSITORY:INSERT USER", () async {
    var user = new User(name: "test", password: "testtest", email: "sample@mail.com");
    userRepository.insertUser(user);
    var users = await userRepository.getAllUsers();
    expect(users[0].name, "test");
    expect(users[0].password, "testtest");
    expect(users[0].email, "sample@mail.com");
    userRepository.deleteUser(users[0].id);
  });

  test("REPOSITORY:DELETE USER", () async {
      List<User> users = await userRepository.getAllUsers();
      for(int i = 0;i < users.length;i++) {
        userRepository.deleteUser(users[i].id);
      }
      List<User> lastUsers = await userRepository.getAllUsers();
      expect(lastUsers.length, 0);
  });

  test("REPOSITORY:UPDATA USER", () async {
      var user = new User(name: "test", password: "testtest", email: "sample@mail.com");
      userRepository.insertUser(user);
      var users = await userRepository.getAllUsers();
      expect(users[0].name, "test");
      expect(users[0].password, "testtest");
      expect(users[0].email, "sample@mail.com");
      var updateUser = new User(
        id: users[0].id, 
        name: "updateTest", 
        password: users[0].password, 
        email: users[0].email,
        updateTime: users[0].updateTime,
        createTime: users[0].createTime,
      );
      userRepository.updateUser(updateUser);
      var updatedUsers = await userRepository.getAllUsers();
      expect(updatedUsers[0].name, "updateTest");
      expect(updatedUsers[0].password, "testtest");
      expect(updatedUsers[0].email, "sample@mail.com");
      for(int i = 0;i < users.length;i++) {
        userRepository.deleteUser(users[i].id);
      }
      List<User> lastUsers = await userRepository.getAllUsers();
      expect(lastUsers.length, 0);
  });
}