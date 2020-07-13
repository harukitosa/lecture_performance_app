import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/Student.dart';
import 'package:lecture_performance_app/services/evaluation_service.dart';
import 'package:lecture_performance_app/services/student_service.dart';

class StudentDto {
  StudentDto(this.student, this.score);
  Student student;
  int score;
}

class StudentProvider with ChangeNotifier {
  StudentProvider({
    @required StudentService student,
    @required EvaluationService evaluation,
    @required int homeroomID,
  })  : _student = student,
        _evaluation = evaluation,
        _homeroomID = homeroomID {
    _updateList();
  }

  final StudentService _student;
  final EvaluationService _evaluation;
  final int _homeroomID;

  final List<StudentDto> _list = [];
  List<StudentDto> get list => _list == null ? [] : List.unmodifiable(_list);

  //:todo Dtoを調べてservice層に移す
  void _updateList() {
    _student.getRoomStudents(_homeroomID).then((value) {
      final list = value;
      for (final item in list) {
        _evaluation.getStudentSum(item.id).then((value) {
          _list.add(StudentDto(item, value));
          notifyListeners();
        });
      }
    });
  }
}
