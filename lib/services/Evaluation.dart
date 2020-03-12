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

  Future<List<Evaluation>> getStudentSemester(int studentID, int semesterID) {
    return evaluationRepository.getStudentSemester(studentID, semesterID);
  }

  Future<int> createEvaluation(int studentID, int typeID, int semesterID, int point) {
    var evaluation = new Evaluation(
      studentID: studentID,
      typeID: typeID,
      semesterID: semesterID,
      point: point,
    );
    var id = evaluationRepository.insertEvaluation(evaluation);
    return id;
  }

  Future<void> editEvaluation(int id, int studentID, int typeID, int semesterID, int point, String createdTime) {
    var evaluation = new Evaluation(
      id: id, 
      studentID: studentID,
      semesterID: semesterID,
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