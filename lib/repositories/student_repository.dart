import 'dart:async';

import 'package:lecture_performance_app/db/models/student.dart';

abstract class IStudentRepository {
  Future<int> insertStudent(Student student);
  Future<List<Student>> getThisRoomStudent(int homeroomID);
  Future<List<Student>> getThisRoomStudentByPos(int homeroomID);
  Future<Student> getOneStudent(int id);
  Future<List<Student>> getAllStudents();
  Future<void> deleteStudent(int id);
  Future<void> updateStudent(Student student);
}
