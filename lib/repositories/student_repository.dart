import 'dart:async';
import 'package:lecture_performance_app/db/models/Student.dart';

abstract class IStudentRepository {
  Future<int> insertStudent(Student student);
  Future<List<Student>> getThisRoomStudent(int homeroomID);
  Future<Student> getOneStudent(int id);
  Future<List<Student>> getAllStudents();
  Future<void> deleteStudent(int id);
  Future<void> updateStudent(Student student);
}
