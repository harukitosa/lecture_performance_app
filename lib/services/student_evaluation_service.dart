import 'package:lecture_performance_app/db/models/Evaluation.dart';
import 'package:lecture_performance_app/repositories/evaluation_repository.dart';
import 'package:lecture_performance_app/repositories/student_repository.dart';
import '../db/models/Student.dart';

class StudentWithEvaluationService {
  final IStudentRepository studentRepository;
  final IEvaluationRepository evaluationRepository;
  StudentWithEvaluationService(this.studentRepository, this.evaluationRepository);
  Future<List<Student>> getRoomStudents(int homeroomID) async {
    var students = await studentRepository.getThisRoomStudent(homeroomID);
    for(int i = 0;i < students.length;i++) {
      var id = students[i].id;
      var list = await evaluationRepository.getStudentSemester(id);
      int sum = 0;
      if (list.isNotEmpty) {
        list.forEach((Evaluation e) {
          sum += e.point;
        });
      }
      students[i].evaluationSum = sum;
            print("student[$i]:"+students[i].name);
      print("sum[$i]:"+students[i].evaluationSum.toString());
    }
    return students;
  }
}