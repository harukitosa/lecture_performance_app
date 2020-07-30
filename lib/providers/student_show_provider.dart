import 'package:flutter/foundation.dart';
import 'package:lecture_performance_app/db/models/evaluation.dart';
import 'package:lecture_performance_app/db/models/student.dart';
import 'package:lecture_performance_app/services/evaluation_service.dart';
import 'package:lecture_performance_app/services/student_service.dart';

class StudentShowProvider with ChangeNotifier {
  StudentShowProvider({
    @required StudentService student,
    @required EvaluationService evaluation,
    @required int studentID,
  })  : _studentService = student,
        _evaluationService = evaluation,
        _id = studentID {
    update();
  }

  final StudentService _studentService;
  final EvaluationService _evaluationService;
  final int _id;

  Student _student;
  Student get value => _student;
  List<Evaluation> _latestEvaluation;
  List<Evaluation> get latestEvaluation =>
      _latestEvaluation == null ? [] : List.unmodifiable(_latestEvaluation);

  void deleteStudent(int id) {
    _studentService.deleteStudent(id).then((res) {
      update();
    });
  }

  void updateStudent(
    int studentId,
    String lastName,
    String firstName,
    int number,
  ) {
    final data = _student;
    _studentService
        .editstudent(
      studentId,
      data.homeRoomID,
      data.positionNum,
      firstName,
      lastName,
      number,
      data.createTime,
    )
        .then(
      (res) {
        update();
      },
    );
  }

  void update() {
    _studentService.getStudent(_id).then((value) {
      _student = value;
      _evaluationService.getLatestStudent(_id).then((value) {
        _latestEvaluation = value;
        notifyListeners();
      });
    });
  }
}
