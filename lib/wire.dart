import 'package:lecture_performance_app/db/models/EvaluationType.dart';
import 'package:lecture_performance_app/repositories/Evaluation.dart';
import 'package:lecture_performance_app/repositories/EvaluationType.dart';
import 'package:lecture_performance_app/repositories/Seat.dart';
import 'package:lecture_performance_app/repositories/Student.dart';
import 'package:lecture_performance_app/repositories/semester.dart';
import 'package:lecture_performance_app/services/Evaluation.dart';
import 'package:lecture_performance_app/services/EvaluationType.dart';
import 'package:lecture_performance_app/services/HomeRoom.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:lecture_performance_app/services/Seat.dart';
import 'package:lecture_performance_app/services/Semester.dart';
import 'package:lecture_performance_app/services/Student.dart';

HomeRoomService initHomeRoomAPI() {
  var _homeRoomRepository = new HomeRoomRepository();
  var _homeRoomService =
      new HomeRoomService(homeRoomRepository: _homeRoomRepository);
  return _homeRoomService;
}

SeatService initSeatAPI() {
  var _seatRepository = new SeatRepository();
  var _seatService = new SeatService(seatRepository: _seatRepository);
  return _seatService;
}

// SemesterService initSemesterAPI() {
//   var _semesterRepository = new SemesterRepository();
//   var _semesterService =
//       new SemesterService(semesterRepository: _semesterRepository);
//   return _semesterService;
// }

StudentService initStudentAPI() {
  var _studentRepository = new StudentRepository();
  var _studentService =
      new StudentService(studentRepository: _studentRepository);
  return _studentService;
}

EvaluationService initEvaluationAPI() {
  var _evaluationRepository = new EvaluationRepository();
  var _evaluationTypeRepository = new EvaluationTypeRepository();
  var _evaluationService = new EvaluationService(
      evaluationRepository: _evaluationRepository,
      evaluationTypeRepository: _evaluationTypeRepository);
  return _evaluationService;
}

EvaluationTypeService initEvaluationTypeAPI() {
  var _evaluationTypeRepository = new EvaluationTypeRepository();
  var _evaluationService = new EvaluationTypeService(
      evaluationTypeRepository: _evaluationTypeRepository);
  return _evaluationService;
}
