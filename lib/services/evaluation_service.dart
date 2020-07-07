import 'package:lecture_performance_app/repositories/evaluation_repository.dart';
import 'package:lecture_performance_app/repositories/evaluation_type_repository.dart';
import '../db/models/Evaluation.dart';
import '../utility/time.dart';

class EvaluationService {
  final IEvaluationRepository evaluationRepository;
  final IEvaluationTypeRepository evaluationTypeRepository;

  EvaluationService(
    this.evaluationRepository,
    this.evaluationTypeRepository,
  );

  Future<List<Evaluation>> getAllEvaluation() {
    return evaluationRepository.getAllEvaluations();
  }

  Future<List<Evaluation>> getStudentSemester(int studentID) async {
    var res = await evaluationRepository.getStudentSemester(studentID);
    for (var i = 0; i < res.length; i++) {
      var ans = await evaluationTypeRepository.getEvaluationType(res[i].typeID);
      res[i].title = ans.title;
    }
    return res;
  }

  Future<List<Evaluation>> getLatestStudent(int studentID) async {
    var res = await evaluationRepository.getLatestStudent(studentID);
    for (var i = 0; i < res.length; i++) {
      var ans = await evaluationTypeRepository.getEvaluationType(res[i].typeID);
      res[i].title = ans.title;
    }
    return res;
  }

  Future<int> getStudentSum(int studentID) async {
    var res = await evaluationRepository.getStudentSemester(studentID);
    int sum = 0;
    if (res.isNotEmpty) {
      res.forEach((Evaluation item) {
        sum += item.point;
      });
    }
    return sum;
  }

  Future<int> createEvaluation(int studentID, int typeID, int point) {
    final evaluation = Evaluation(
      studentID: studentID,
      typeID: typeID,
      point: point,
    );
    final id = evaluationRepository.insertEvaluation(evaluation);
    return id;
  }

  Future<void> editEvaluation(
      int id, int studentID, int typeID, int point, String createdTime) {
    var evaluation = new Evaluation(
      id: id,
      studentID: studentID,
      typeID: typeID,
      point: point,
      createTime: createdTime,
      updateTime: getNowTime(),
    );
    return evaluationRepository.updateEvaluation(evaluation);
  }

  Future<void> deleteEvaluation(int id) {
    return evaluationRepository.deleteEvaluation(id);
  }
}
