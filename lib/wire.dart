import 'package:lecture_performance_app/infrastructure/sqlite/evaluation_repository.dart';
import 'package:lecture_performance_app/infrastructure/sqlite/evaluation_type_repository.dart';
import 'package:lecture_performance_app/infrastructure/sqlite/homeroom_repository.dart';
import 'package:lecture_performance_app/infrastructure/sqlite/seat_repository.dart';
import 'package:lecture_performance_app/infrastructure/sqlite/student_repository.dart';
import 'package:lecture_performance_app/services/evaluation_service.dart';
import 'package:lecture_performance_app/services/evaluation_type_service.dart';
import 'package:lecture_performance_app/services/homeroom_service.dart';
import 'package:lecture_performance_app/services/seat_service.dart';
import 'package:lecture_performance_app/services/student_service.dart';

/// 依存性の注入を行っている
HomeRoomService initHomeRoomAPI() {
  var _homeRoomRepository = new HomeRoomRepository();
  var _homeRoomService = new HomeRoomService(_homeRoomRepository);
  return _homeRoomService;
}

SeatService initSeatAPI() {
  var _seatRepository = new SeatRepository();
  var _seatService = new SeatService(_seatRepository);
  return _seatService;
}

StudentService initStudentAPI() {
  var _studentRepository = new StudentRepository();
  var _studentService = new StudentService(_studentRepository);
  return _studentService;
}

EvaluationService initEvaluationAPI() {
  var _evaluationRepository = new EvaluationRepository();
  var _evaluationTypeRepository = new EvaluationTypeRepository();
  var _evaluationService =
      new EvaluationService(_evaluationRepository, _evaluationTypeRepository);
  return _evaluationService;
}

EvaluationTypeService initEvaluationTypeAPI() {
  var _evaluationTypeRepository = new EvaluationTypeRepository();
  var _evaluationRepository = new EvaluationRepository();
  var _evaluationService = new EvaluationTypeService(
      _evaluationTypeRepository, _evaluationRepository);
  return _evaluationService;
}
