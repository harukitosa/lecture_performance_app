
import 'package:lecture_performance_app/repositories/Evaluation.dart';
import 'package:lecture_performance_app/services/Evaluation.dart';
import 'package:lecture_performance_app/repositories/EvaluationType.dart';
import 'package:lecture_performance_app/services/EvaluationType.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:lecture_performance_app/services/HomeRoom.dart';
import 'package:lecture_performance_app/repositories/Student.dart';
import 'package:lecture_performance_app/services/Student.dart';
import 'package:lecture_performance_app/repositories/semester.dart';
import 'package:lecture_performance_app/services/semester.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

void testEvaluationService() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
  Database db = await initDB();
  var evaluationRepository = new EvaluationRepository(db: db);
  var evaluationService = new EvaluationService(evaluationRepository: evaluationRepository);
  var evaluationTypeRepository = new EvaluationTypeRepository(db: db);
  var evaluationTypeService = new EvaluationTypeService(evaluationTypeRepository: evaluationTypeRepository);
  var studentRepository = new StudentRepository(db: db);
  var studentService = new StudentService(studentRepository: studentRepository);
  var homeRoomRepository = new HomeRoomRepository(db: db);
  var homeRoomService = new HomeRoomService(homeRoomRepository: homeRoomRepository);
  var semesterRepository = new SemesterRepository(db: db);
  var semesterService = new SemesterService(semesterRepository: semesterRepository);

  test('SERVICE:Evaluation',() async {
    var typeID = await evaluationTypeService.createEvaluationType('発音');
    var typeID2 = await evaluationTypeService.createEvaluationType('積極性');
    var homeRoomID = await homeRoomService.createHomeRoom(2, 2);
    var studentID = await studentService.createstudent(homeRoomID, "sample");
    var semesterID = await semesterService.createsemester('春学期', homeRoomID);
    await evaluationService.createEvaluation(studentID, typeID, semesterID, 2);
    var evaluationList = await evaluationService.getAllEvaluation();
    expect(evaluationList[0].point, 2);
    await evaluationService.editEvaluation(
      evaluationList[0].id, 
      studentID, 
      typeID2, 
      semesterID, 
      3, 
      evaluationList[0].createTime,
    );
    var updateList = await evaluationService.getAllEvaluation();
    expect(updateList[0].typeID, typeID2);
    expect(updateList[0].point, 3);
    await evaluationService.createEvaluation(studentID, typeID, semesterID, 1);
    var target = await evaluationService.getStudentSemester(studentID, semesterID);
    expect(target[0].typeID, typeID2);
    expect(target[0].point, 3);
    expect(target[1].typeID, typeID);
    expect(target[1].point, 1);
    expect(target.length, 2);
    await evaluationService.deleteEvaluation(target[0].id);
    await evaluationService.deleteEvaluation(target[1].id);
    var deleteList = await evaluationService.getAllEvaluation();
    expect(deleteList.length, 0);
  });
}