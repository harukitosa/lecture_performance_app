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

  List<StudentDto> _list = [];
//  List<StudentDto> get list => _list == null ? [] : List.unmodifiable(_list);

  List<StudentDto> getList(int homeroomId) {
    print(homeroomId);
    if (_list == null) {
      return [];
    } else {
      return List.unmodifiable(
        _list
          ..where((item) => item.student.homeRoomID == homeroomId)
          ..sort((a, b) => a.student.number.compareTo(b.student.number))
          ..toList(),
      );
    }
  }

  StudentDto getStudent(int studentId) {
    for (final item in _list) {
      if (item.student.id == studentId) {
        return item;
      }
    }
  }

  void deleteStudent(int id) {
    _student.deleteStudent(id).then((res) {
      _updateList();
    });
  }

  void updateStudent(
    int studentId,
    String lastName,
    String firstName,
    int number,
  ) {
    final data = _list.where((item) => item.student.id == studentId).toList();
    _student
        .editstudent(
      studentId,
      data[0].student.homeRoomID,
      data[0].student.positionNum,
      firstName,
      lastName,
      number,
      data[0].student.createTime,
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
