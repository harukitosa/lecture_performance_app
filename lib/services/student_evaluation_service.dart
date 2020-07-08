import 'package:lecture_performance_app/db/models/Evaluation.dart';
import 'package:lecture_performance_app/repositories/evaluation_repository.dart';
import 'package:lecture_performance_app/repositories/student_repository.dart';
import '../db/models/Student.dart';

class StudentWithEvaluationService {
  StudentWithEvaluationService(
      this.studentRepository, this.evaluationRepository);
  final IStudentRepository studentRepository;
  final IEvaluationRepository evaluationRepository;

  Future<List<Student>> getRoomStudents(int homeroomID) async {
    final students = await studentRepository.getThisRoomStudent(homeroomID);
    for (var i = 0; i < students.length; i++) {
      final id = students[i].id;
      final list = await evaluationRepository.getStudentSemester(id);
      var sum = 0;

      if (list.isNotEmpty) {
        var time = list[0].createTime;
        for (final e in list) {
          sum += e.point;

          /// 一番当たってから時間が立っている
          if (time.compareTo(e.createTime) < 0) {
            time = e.createTime;
          }
        }
        students[i].lastTime = time;
      }
      students[i].evaluationSum = sum;
    }
    return students;
  }
}
