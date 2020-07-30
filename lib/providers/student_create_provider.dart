import 'package:flutter/foundation.dart';
import 'package:lecture_performance_app/services/student_service.dart';

class StudentCreateProvider with ChangeNotifier {
  StudentCreateProvider({
    @required StudentService student,
  }) : _studentService = student;
  final StudentService _studentService;

  void createStudent(
    int homeRoomID,
    String firstName,
    String lastName,
    int number,
  ) {
    _studentService
        .createStudent(homeRoomID, firstName, lastName, number)
        .then((value) {});
  }
}
