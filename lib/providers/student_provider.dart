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
  })  : _student = student,
        _evaluation = evaluation {
    _updateList();
  }

  final StudentService _student;
  final EvaluationService _evaluation;

  final List<StudentDto> _list = [];
//  List<StudentDto> get list => _list == null ? [] : List.unmodifiable(_list);

  List<StudentDto> getList(int homeroomId) {
    if (_list == null) {
      return [];
    } else {
      return List.unmodifiable(
        _list.where((item) => item.student.homeRoomID == homeroomId).toList(),
      );
    }
  }

  StudentDto getStudent(int studentId) {
    return _list.where((item) => item.student.id == studentId).toList()[0];
  }

  void updateStudent(
    int studentId,
    String lastName,
    String firstName,
    int number,
  ) {
    final data =
        _list.where((item) => item.student.id == studentId).toList()[0];
    _student
        .editstudent(
      studentId,
      data.student.homeRoomID,
      data.student.positionNum,
      firstName,
      lastName,
      number,
      data.student.createTime,
    )
        .then(
      (res) {
        _updateList();
      },
    );
  }

  //:todo Dtoを調べてservice層に移す
  void _updateList() {
    _student.getAllStudent().then((value) {
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
