import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/db/models/Student.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:lecture_performance_app/db/models/User.dart';
import 'package:lecture_performance_app/repositories/Student.dart';
import 'package:lecture_performance_app/repositories/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void testStudentRepository() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
  Database db = await initDB();
  var homeRoomRepository = new HomeRoomRepository(db: db);
  var userRepository = new UserRepository(db: db);
  var studentRepository = new StudentRepository(db: db);

  test('REPOSITORY:INSERT STUDENT', () async {
      var user = new User(name: "test", password: "testtest", email: "sample@mail.com");
      await userRepository.insertUser(user);
      var users = await userRepository.getAllUsers();
      var homeRoom = new HomeRoom(userID: users[0].id, grade: 1, lectureClass: 2);
      homeRoomRepository.insertHomeRoom(homeRoom);
      var homeRooms = await homeRoomRepository.getHomeRooms(users[0].id);
      var student = new Student(homeRoomID: homeRooms[0].id, name: "サンプル太郎");
      studentRepository.insertStudent(student);
      var students = await studentRepository.getThisRoomStudent(homeRooms[0].id);

      expect(students[0].homeRoomID, homeRooms[0].id);
      expect(students[0].name, "サンプル太郎");
  });

  test('REPOSITORY:DELETE STUDENT', () async {
      var user = new User(name: "test", password: "testtest", email: "sample@mail.com");
      await userRepository.insertUser(user);
      var users = await userRepository.getAllUsers();
      var homeRoom = new HomeRoom(userID: users[0].id, grade: 1, lectureClass: 2);
      homeRoomRepository.insertHomeRoom(homeRoom);
      var homeRooms = await homeRoomRepository.getHomeRooms(users[0].id);
      var student = new Student(homeRoomID: homeRooms[0].id, name: "サンプル太郎");
      var student1 = new Student(homeRoomID: homeRooms[0].id, name: "サンプル太郎1");
      var student2 = new Student(homeRoomID: homeRooms[0].id, name: "サンプル太郎2");
      studentRepository.insertStudent(student);
      studentRepository.insertStudent(student1);
      studentRepository.insertStudent(student2);
      var students = await studentRepository.getAllStudents(); 
      for(int i = 0;i < students.length;i++) {
        studentRepository.deleteStudent(students[i].id);
      }
      var allStudent = await studentRepository.getAllStudents();

      expect(allStudent.length, 0);
  });

  test('REPOSITORY:UPDATE STUDENT', () async {
      var user = new User(name: "test", password: "testtest", email: "sample@mail.com");
      await userRepository.insertUser(user);
      var users = await userRepository.getAllUsers();
      var homeRoom = new HomeRoom(userID: users[0].id, grade: 1, lectureClass: 2);
      homeRoomRepository.insertHomeRoom(homeRoom);
      var homeRooms = await homeRoomRepository.getHomeRooms(users[0].id);
      var student = new Student(homeRoomID: homeRooms[0].id, name: "サンプル太郎");
      var id = await studentRepository.insertStudent(student);
      var beforeStudent = await studentRepository.getOneStudent(id);
      var updateStudent = new Student(id: beforeStudent.id, homeRoomID: beforeStudent.homeRoomID, name: "アップデータと太郎", createTime: beforeStudent.createTime, updateTime: beforeStudent.updateTime);
      studentRepository.updateStudent(updateStudent);
      var resultStudent = await studentRepository.getOneStudent(beforeStudent.id);
      
      expect(resultStudent.name, "アップデータと太郎");
  });
}