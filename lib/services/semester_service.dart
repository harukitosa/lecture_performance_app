import 'package:lecture_performance_app/repositories/semester.dart';
import '../db/models/Semester.dart';
import '../utility/time.dart';
class SemesterService {

  final SemesterRepository semesterRepository;
  SemesterService(
    this.semesterRepository
  );

  Future<List<Semester>> getAllsemester() {
    return semesterRepository.getAllSemesters();
  }

  Future<int> createsemester(String title, int homeroomID) {
    var semester = new Semester(title: title, homeRoomID: homeroomID);
    var id = semesterRepository.insertSemester(semester);
    return id;
  }

  Future<void> editsemester(int id, int homeroomID, String title, String createdTime) {
    var semester = new Semester(
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