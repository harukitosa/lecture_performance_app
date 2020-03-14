import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/repositories/Evaluation.dart';
import 'package:lecture_performance_app/repositories/EvaluationType.dart';
import 'package:lecture_performance_app/repositories/Semester.dart';
import 'package:lecture_performance_app/repositories/Student.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:lecture_performance_app/repositories/User.dart';
import 'package:lecture_performance_app/db/models/User.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/db/models/Evaluation.dart' as eval;
import 'package:lecture_performance_app/db/models/EvaluationType.dart';
import 'package:lecture_performance_app/db/models/Semester.dart';
import 'package:lecture_performance_app/db/models/Student.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void testEvaluationRepository() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
    var evaluationRepository = new EvaluationRepository();
    var evaluationTypeRepository = new EvaluationTypeRepository();
    var studentRepository = new StudentRepository();
    var semesterRepository = new SemesterRepository();
    var userRepository = new UserRepository();
    var homeRoomRepository = new HomeRoomRepository();

    test('REPOSITORY:INSERT EVALUATION', () async {
      var evaluationType = new EvaluationType(title: "いいね");
      var evaluationTypeID = await evaluationTypeRepository.insertEvaluationType(evaluationType);
      var user = new User(name: "test", password: "testtest", email: "sample@mail.com");
      await userRepository.insertUser(user);
      var homeRoom = new HomeRoom(grade: "1", lectureClass: "2");
      var homeRoomID = await homeRoomRepository.insertHomeRoom(homeRoom);
      var student = new Student(homeRoomID: homeRoomID, name: "サンプル太郎");
      var studentID = await studentRepository.insertStudent(student);
      var semester = new Semester(homeRoomID: homeRoomID, title: "春学期");
      var semesterID = await semesterRepository.insertSemester(semester);
      var evaluation = new eval.Evaluation(studentID: studentID, semesterID: semesterID, typeID: evaluationTypeID, point: 2);
      var id = await evaluationRepository.insertEvaluation(evaluation);
      var res = await evaluationRepository.getEvaluation(id);
      expect(res.studentID, studentID);
      expect(res.typeID, evaluationTypeID);
      expect(res.studentID, studentID);
      expect(res.point, 2);
      await evaluationRepository.deleteEvaluation(id);
    });

    test('REPOSITORY:DELETE EVALUATION', () async {
      var evaluationType = new EvaluationType(title: "いいね");
      var evaluationTypeID = await evaluationTypeRepository.insertEvaluationType(evaluationType);
      var user = new User(name: "test", password: "testtest", email: "sample@mail.com");
      await userRepository.insertUser(user);
      var homeRoom = new HomeRoom(grade: "1", lectureClass: "2");
      var homeRoomID = await homeRoomRepository.insertHomeRoom(homeRoom);
      var student = new Student(homeRoomID: homeRoomID, name: "サンプル太郎");
      var studentID = await studentRepository.insertStudent(student);
      var semester = new Semester(homeRoomID: homeRoomID, title: "春学期");
      var semesterID = await semesterRepository.insertSemester(semester);
      var evaluation = new eval.Evaluation(studentID: studentID, semesterID: semesterID, typeID: evaluationTypeID, point: 2);
      var id = await evaluationRepository.insertEvaluation(evaluation);
      var res = await evaluationRepository.getEvaluation(id);
      expect(res.studentID, studentID);
      expect(res.typeID, evaluationTypeID);
      expect(res.studentID, studentID);
      expect(res.point, 2);
      await evaluationRepository.deleteEvaluation(id);
      var resSec = await evaluationRepository.getAllEvaluations();
      expect(resSec.length, 0);
    });

    test('REPOSITORY:UPDATE EVALUATION', () async {
      var evaluationType = new EvaluationType(title: "いいね");
      var evaluationTypeID = await evaluationTypeRepository.insertEvaluationType(evaluationType);
      var user = new User(name: "test", password: "testtest", email: "sample@mail.com");
      await userRepository.insertUser(user);
      var homeRoom = new HomeRoom(grade: "1", lectureClass: "2");
      var homeRoomID = await homeRoomRepository.insertHomeRoom(homeRoom);
      var student = new Student(homeRoomID: homeRoomID, name: "サンプル太郎");
      var studentID = await studentRepository.insertStudent(student);
      var semester = new Semester(homeRoomID: homeRoomID, title: "春学期");
      var semesterID = await semesterRepository.insertSemester(semester);
      var evaluation = new eval.Evaluation(studentID: studentID, semesterID: semesterID, typeID: evaluationTypeID, point: 2);
      var id = await evaluationRepository.insertEvaluation(evaluation);
      var res = await evaluationRepository.getEvaluation(id);
      expect(res.studentID, studentID);
      expect(res.typeID, evaluationTypeID);
      expect(res.studentID, studentID);
      expect(res.point, 2);
      print("createTime");
      print(res.createTime);
      print("updateTime");
      print(res.updateTime);
      var update = new eval.Evaluation(id: res.id, studentID: studentID, semesterID: semesterID, typeID: evaluationTypeID, point: 100, createTime: res.createTime, updateTime: res.updateTime);
      await evaluationRepository.updateEvaluation(update);
      var secRes = await evaluationRepository.getEvaluation(res.id);
      expect(secRes.point, 100);
      expect(secRes.studentID, studentID);
      expect(secRes.typeID, evaluationTypeID);
      expect(secRes.studentID, studentID);
    });
}