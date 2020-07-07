import 'package:lecture_performance_app/repositories/evaluation_repository.dart';
import 'package:lecture_performance_app/repositories/evaluation_type_repository.dart';
import '../db/models/EvaluationType.dart';
import '../utility/time.dart';

class SumEvaluationType {
  final int id;
  final String title;
  final int point;
  SumEvaluationType({this.id, this.title, this.point});
}

class EvaluationTypeService {
  final IEvaluationTypeRepository evaluationTypeRepository;
  final IEvaluationRepository evaluationRepository;
  EvaluationTypeService(
    this.evaluationTypeRepository,
    this.evaluationRepository,
  );

  Future<List<EvaluationType>> getAllEvaluationType() {
    return evaluationTypeRepository.getAllEvaluationTypes();
  }

  Future<EvaluationType> getEvaluationType(id) {
    return evaluationTypeRepository.getEvaluationType(id);
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

  Future<List<SumEvaluationType>> getEvaluationSum(int studentID) async {
    var data = await evaluationTypeRepository.getAllEvaluationTypes();
    List<SumEvaluationType> list = [];
    for (var i = 0; i < data.length; i++) {
      var res =
          await evaluationRepository.getEvaluationByType(data[i].id, studentID);
      var sum = 0;
      for (var j = 0; j < res.length; j++) {
        sum += res[j].point;
      }
      list.add(new SumEvaluationType(
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
