import 'package:lecture_performance_app/infrastructure/sqlite/evaluation_repository.dart';
import 'package:lecture_performance_app/infrastructure/sqlite/evaluation_type_repository.dart';
import 'package:lecture_performance_app/infrastructure/sqlite/homeroom_repository.dart';
import 'package:lecture_performance_app/infrastructure/sqlite/seat_repository.dart';
import 'package:lecture_performance_app/infrastructure/sqlite/student_repository.dart';
import 'package:lecture_performance_app/services/evaluation_service.dart';
import 'package:lecture_performance_app/services/evaluation_type_service.dart';
import 'package:lecture_performance_app/services/homeroom_service.dart';
import 'package:lecture_performance_app/services/seat_service.dart';
import 'package:lecture_performance_app/services/student_evaluation_service.dart';
import 'package:lecture_performance_app/services/student_service.dart';

/// 依存性の注入を行っている
HomeRoomService initHomeRoomAPI() {
  final _homeRoomRepository = HomeRoomRepository();
  final _homeRoomService = HomeRoomService(_homeRoomRepository);
  return _homeRoomService;
}

SeatService initSeatAPI() {
  final _seatRepository = SeatRepository();
  final _seatService = SeatService(_seatRepository);
  return _seatService;
}

StudentService initStudentAPI() {
  final _studentRepository = StudentRepository();
  final _studentService = StudentService(_studentRepository);
  return _studentService;
}

EvaluationService initEvaluationAPI() {
  final _evaluationRepository = EvaluationRepository();
  final _evaluationTypeRepository = EvaluationTypeRepository();
  final _evaluationService =
      EvaluationService(_evaluationRepository, _evaluationTypeRepository);
  return _evaluationService;
}

EvaluationTypeService initEvaluationTypeAPI() {
  final _evaluationTypeRepository = EvaluationTypeRepository();
  final _evaluationRepository = EvaluationRepository();
  final _evaluationService =
      EvaluationTypeService(_evaluationTypeRepository, _evaluationRepository);
  return _evaluationService;
}

StudentWithEvaluationService initStudentWithEvaluationServiceAPI() {
  final _evaluationRepository = EvaluationRepository();
  final _studentRepository = StudentRepository();
  final _sweService =
      StudentWithEvaluationService(_studentRepository, _evaluationRepository);
  return _sweService;
}
