import 'package:lecture_performance_app/repositories/evaluation_repository.dart';
import 'package:lecture_performance_app/repositories/evaluation_type_repository.dart';
import '../db/models/EvaluationType.dart';
import '../utility/time.dart';

class SumEvaluationType {
  SumEvaluationType({this.id, this.title, this.point});
  final int id;
  final String title;
  final int point;
}

class EvaluationTypeService {
  EvaluationTypeService(
    this.evaluationTypeRepository,
    this.evaluationRepository,
  );

  final IEvaluationTypeRepository evaluationTypeRepository;
  final IEvaluationRepository evaluationRepository;

  Future<List<EvaluationType>> getAllEvaluationType() {
    return evaluationTypeRepository.getAllEvaluationTypes();
  }

  Future<EvaluationType> getEvaluationType(int id) {
    return evaluationTypeRepository.getEvaluationType(id);
  }

  Future<int> createEvaluationType(String title) {
    final evaluationType = EvaluationType(title: title);
    final id = evaluationTypeRepository.insertEvaluationType(evaluationType);
    return id;
  }

  Future<void> editEvaluationType(int id, String title, String createdTime) {
    final evaluationType = EvaluationType(
      id: id,
      title: title,
      createTime: createdTime,
      updateTime: getNowTime(),
    );
    return evaluationTypeRepository.updateEvaluationType(evaluationType);
  }

  Future<List<SumEvaluationType>> getEvaluationSum(int studentID) async {
    final data = await evaluationTypeRepository.getAllEvaluationTypes();
    final list = <SumEvaluationType>[];
    for (var i = 0; i < data.length; i++) {
      final res =
          await evaluationRepository.getEvaluationByType(data[i].id, studentID);
      var sum = 0;
      for (var j = 0; j < res.length; j++) {
        sum += res[j].point;
      }
      list.add(SumEvaluationType(
        id: data[i].id,
        point: sum,
        title: data[i].title,
      ));
    }
    return list;
  }

  Future<void> deleteEvaluationType(int id) {
    return evaluationTypeRepository.deleteEvaluationType(id);
  }
}
