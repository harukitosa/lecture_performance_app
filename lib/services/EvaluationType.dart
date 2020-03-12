import 'package:lecture_performance_app/repositories/EvaluationType.dart';
import '../db/models/EvaluationType.dart';
import '../utility/time.dart';
class EvaluationTypeService {

  final EvaluationTypeRepository evaluationTypeRepository;
  EvaluationTypeService({
    this.evaluationTypeRepository
  });

  Future<List<EvaluationType>> getAllEvaluationType() {
    return evaluationTypeRepository.getAllEvaluationTypes();
  }

  Future<int> createEvaluationType(String title) {
    var evaluationType = new EvaluationType(title: title);
    var id = evaluationTypeRepository.insertEvaluationType(evaluationType);
    return id;
  }

  Future<void> editEvaluationType(int id, String title, String createdTime) {
    var evaluationType = new EvaluationType(
      id: id, 
      title: title,
      createTime: createdTime,
      updateTime: getNowTime(),
    );
    return evaluationTypeRepository.updateEvaluationType(evaluationType);
  }

  Future<void> deleteEvaluationType(int id) {
    return evaluationTypeRepository.deleteEvaluationType(id);
  }
}