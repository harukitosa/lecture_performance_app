import 'package:lecture_performance_app/infrastructure/sqlite/semester_repository.dart';
import '../db/models/Semester.dart';
import '../utility/time.dart';

class SemesterService {
  SemesterService(this.semesterRepository);

  final SemesterRepository semesterRepository;

  Future<List<Semester>> getAllsemester() {
    return semesterRepository.getAllSemesters();
  }

  Future<int> createsemester(String title, int homeroomID) {
    final semester = Semester(title: title, homeRoomID: homeroomID);
    final id = semesterRepository.insertSemester(semester);
    return id;
  }

  Future<void> editsemester(
      int id, int homeroomID, String title, String createdTime) {
    final semester = Semester(
      id: id,
      homeRoomID: homeroomID,
      title: title,
      createTime: createdTime,
      updateTime: getNowTime(),
    );
    return semesterRepository.updateSemester(semester);
  }

  Future<void> deletesemester(int id) {
    return semesterRepository.deleteSemester(id);
  }
}
