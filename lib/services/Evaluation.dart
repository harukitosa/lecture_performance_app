import 'package:lecture_performance_app/repositories/Evaluation.dart';
import '../db/models/Evaluation.dart';
import '../utility/time.dart';
class EvaluationService {

  final EvaluationRepository evaluationRepository;
  EvaluationService({
    this.evaluationRepository
  });

  Future<List<Evaluation>> getAllEvaluation() {
    return evaluationRepository.getAllEvaluations();
  }

  Future<List<Evaluation>> getStudentSemester(int studentID) {
    return evaluationRepository.getStudentSemester(studentID);
  }

  Future<int> createEvaluation(int studentID, int typeID, int point) {
    var evaluation = new Evaluation(
      studentID: studentID,
      typeID: typeID,
      point: point,
    );
    var id = evaluationRepository.insertEvaluation(evaluation);
    return id;
  }

  Future<void> editEvaluation(int id, int studentID, int typeID,  int point, String createdTime) {
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