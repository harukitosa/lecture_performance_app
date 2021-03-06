import 'package:lecture_performance_app/db/models/evaluation.dart';
import 'package:lecture_performance_app/repositories/evaluation_repository.dart';
import 'package:lecture_performance_app/repositories/evaluation_type_repository.dart';

import '../utility/time.dart';

class EvaluationService {
  EvaluationService(
    this.evaluationRepository,
    this.evaluationTypeRepository,
  );
  final IEvaluationRepository evaluationRepository;
  final IEvaluationTypeRepository evaluationTypeRepository;

  Future<List<Evaluation>> getAllEvaluation() {
    return evaluationRepository.getAllEvaluations();
  }

  Future<List<Evaluation>> getStudentSemester(int studentID) async {
    final res = await evaluationRepository.getStudentSemester(studentID);
    for (var i = 0; i < res.length; i++) {
      final a = await evaluationTypeRepository.getEvaluationType(res[i].typeID);
      res[i].title = a.title;
    }
    return res;
  }

  Future<List<Evaluation>> getLatestStudent(int studentID) async {
    final res = await evaluationRepository.getLatestStudent(studentID);
    for (var i = 0; i < res.length; i++) {
      final a = await evaluationTypeRepository.getEvaluationType(res[i].typeID);
      res[i].title = a.title;
    }
    return res;
  }

  Future<int> getStudentSum(int studentID) async {
    final res = await evaluationRepository.getStudentSemester(studentID);
    var sum = 0;
    if (res.isNotEmpty) {
      for (final item in res) {
        sum += item.point;
      }
    }
    return sum;
  }

  Future<int> getStudentCount(int studentID) async {
    final res = await evaluationRepository.getStudentSemester(studentID);
    return res.length;
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

  Future<Evaluation> getEvaluation(int id) {
    return evaluationRepository.getEvaluation(id);
  }

  Future<void> editEvaluation(
      int id, int studentID, int typeID, int point, String createdTime) {
    final evaluation = Evaluation(
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
