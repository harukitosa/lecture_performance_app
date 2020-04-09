import 'dart:async';
import 'package:lecture_performance_app/db/models/EvaluationType.dart';

abstract class IEvaluationTypeRepository {
  Future<int> insertEvaluationType(EvaluationType evaluationType);
  Future<EvaluationType> getEvaluationType(int id);
  Future<List<EvaluationType>> getAllEvaluationTypes();
  Future<void> deleteEvaluationType(int id);
  Future<void> updateEvaluationType(EvaluationType evaluationType);
}


