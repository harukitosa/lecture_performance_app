import 'package:lecture_performance_app/db/models/Semester.dart';

abstract class ISemesterRepository {
  Future<int> insertSemester(Semester semester);
  Future<Semester> getSemester(int id);
  Future<List<Semester>> getAllSemesters();
  Future<void> deleteSemester(int id);
  Future<int> updateSemester(Semester semester);
}

