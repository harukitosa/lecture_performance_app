import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/student.dart';
import 'package:lecture_performance_app/services/evaluation_service.dart';
import 'package:lecture_performance_app/services/student_service.dart';

class StudentDto {
  StudentDto(this.student, this.score);
  Student student;
  int score;
}

class StudentIndexProvider with ChangeNotifier {
  StudentIndexProvider({
    @required StudentService student,
    @required EvaluationService evaluation,
    @required int homeroomID,
  })  : _student = student,
        _evaluation = evaluation,
        _homeroomID = homeroomID {
    updateList();
  }

  final StudentService _student;
  final EvaluationService _evaluation;
  final int _homeroomID;

  List<StudentDto> _list = [];
  List<StudentDto> get list => _list == null ? [] : List.unmodifiable(_list);

  //:todo Dtoを調べてservice層に移す
  void updateList() {
    print('updateList');
    _student.getRoomStudents(_homeroomID).then((value) {
      final list = value;
      _list = [];
      for (final item in list) {
        _evaluation.getStudentSum(item.id).then((value) {
          _list.add(StudentDto(item, value));
          notifyListeners();
        });
      }
    });
  }
}
