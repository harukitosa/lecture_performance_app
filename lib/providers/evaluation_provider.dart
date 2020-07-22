import 'package:flutter/foundation.dart';
import 'package:lecture_performance_app/db/models/evaluation.dart';
import 'package:lecture_performance_app/services/evaluation_service.dart';

class EvaluationProvider with ChangeNotifier {
  EvaluationProvider({@required EvaluationService evaluation})
      : _evaluation = evaluation {
    _updateList();
  }

  final EvaluationService _evaluation;

  List<Evaluation> _list;
  List<Evaluation> get list => _list == null ? [] : List.unmodifiable(_list);

  List<Evaluation> studentLatestScore(int studentID) {
    _list
      ..where((item) => item.studentID == studentID)
      ..sort((a, b) => b.createTime.compareTo(a.createTime));
    return _list.toList() != null ? _list.sublist(0, 10) : [];
  }

  void _updateList() {
    _evaluation.getAllEvaluation().then((value) {
      _list = value;
      notifyListeners();
    });
  }
}
