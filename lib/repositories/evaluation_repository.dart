import 'dart:async';

import 'package:lecture_performance_app/db/models/evaluation.dart';

abstract class IEvaluationRepository {
  Future<int> insertEvaluation(Evaluation evaluation);
  Future<Evaluation> getEvaluation(int id);
  Future<List<Evaluation>> getStudentSemester(int studentID);
  Future<List<Evaluation>> getEvaluationByType(int typeID, int studentID);
  Future<List<Evaluation>> getLatestStudent(int studentID);
  Future<List<Evaluation>> getAllEvaluations();
  Future<void> deleteEvaluation(int id);
  Future<void> updateEvaluation(Evaluation evaluation);
}
