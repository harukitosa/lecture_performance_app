import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/db/models/Student.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:lecture_performance_app/repositories/Student.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void testStudentRepository() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
  var homeRoomRepository = new HomeRoomRepository();
  var studentRepository = new StudentRepository();

  test('REPOSITORY:INSERT STUDENT', () async {
      var homeRoom = new HomeRoom(grade: "1", lectureClass: "2");
      homeRoomRepository.insertHomeRoom(homeRoom);
      var homeRooms = await homeRoomRepository.getHomeRooms();
      var student = new Student(homeRoomID: homeRooms[0].id, name: "サンプル太郎", positionNum: 17);
      await studentRepository.insertStudent(student);
      var students = await studentRepository.getThisRoomStudent(homeRooms[0].id);

      expect(students[0].homeRoomID, homeRooms[0].id);
      expect(students[0].name, "サンプル太郎");
      expect(students[0].positionNum, 17);
  });

  test('REPOSITORY:DELETE STUDENT', () async {
      var homeRoom = new HomeRoom(grade: "1", lectureClass: "2");
      homeRoomRepository.insertHomeRoom(homeRoom);
      var homeRooms = await homeRoomRepository.getHomeRooms();
      var student = new Student(homeRoomID: homeRooms[0].id, name: "サンプル太郎", positionNum: 2);
      var student1 = new Student(homeRoomID: homeRooms[0].id, name: "サンプル太郎1", positionNum: 3);
      var student2 = new Student(homeRoomID: homeRooms[0].id, name: "サンプル太郎2", positionNum: 4);
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
      var homeRoom = new HomeRoom(grade: "1", lectureClass: "2");
      homeRoomRepository.insertHomeRoom(homeRoom);
      var homeRooms = await homeRoomRepository.getHomeRooms();
      var student = new Student(homeRoomID: homeRooms[0].id, name: "サンプル太郎", positionNum: 1);
      var id = await studentRepository.insertStudent(student);
      var beforeStudent = await studentRepository.getOneStudent(id);
      var updateStudent = new Student(id: beforeStudent.id, homeRoomID: beforeStudent.homeRoomID, name: "アップデータと太郎",positionNum: 3, createTime: beforeStudent.createTime, updateTime: beforeStudent.updateTime);
      studentRepository.updateStudent(updateStudent);
      var resultStudent = await studentRepository.getOneStudent(beforeStudent.id);
      expect(resultStudent.name, "アップデータと太郎");
      expect(resultStudent.positionNum, 3);
  });
}