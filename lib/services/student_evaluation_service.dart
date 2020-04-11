import 'package:lecture_performance_app/db/models/Evaluation.dart';
import 'package:lecture_performance_app/repositories/evaluation_repository.dart';
import 'package:lecture_performance_app/repositories/student_repository.dart';
import '../db/models/Student.dart';

class StudentWithEvaluationService {
  final IStudentRepository studentRepository;
  final IEvaluationRepository evaluationRepository;
  StudentWithEvaluationService(
      this.studentRepository, this.evaluationRepository);
  Future<List<Student>> getRoomStudents(int homeroomID) async {
    var students = await studentRepository.getThisRoomStudent(homeroomID);
    for (int i = 0; i < students.length; i++) {
      var id = students[i].id;
      var list = await evaluationRepository.getStudentSemester(id);
      int sum = 0;

      if (list.isNotEmpty) {
        String time = list[0].createTime;
        list.forEach((Evaluation e) {
          sum += e.point;
          /// 一番当たってから時間が立っている
          if (time.compareTo(e.createTime) < 0) {
            time = e.createTime;
          }
        });
        students[i].lastTime = time;
      }
      students[i].evaluationSum = sum;
    }
    return students;
  }
}
