import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/evaluation_type.dart';
import 'package:lecture_performance_app/services/evaluation_type_service.dart';
import 'package:lecture_performance_app/wire.dart';

class EvaluationProvider with ChangeNotifier {
  EvaluationProvider() {
    _evaluationTypeService = initEvaluationTypeAPI();
    getAllEvaluationType();
    notifyListeners();
  }
  EvaluationTypeService _evaluationTypeService;
  int currentTypeID;
  double x = 0;
  double y = 0;

  void position(double dx, double dy) {
    x = dx;
    y = dy;
    notifyListeners();
  }

  List<EvaluationType> _evaluationSelect;
  List<EvaluationType> get getEvaluationSelect => _evaluationSelect;

  Future<void> getAllEvaluationType() async {
    await _evaluationTypeService
        .getAllEvaluationType()
        .then((res) => _evaluationSelect = res);
    currentTypeID = _evaluationSelect[0].id - 1;
    notifyListeners();
  }

  void changeTypeLeft() {
    if (currentTypeID != 0) {
      currentTypeID--;
    } else {
      currentTypeID = _evaluationSelect.length - 1;
    }
    notifyListeners();
  }

  void changeTypeRight() {
    if (currentTypeID == _evaluationSelect.length - 1) {
      currentTypeID = 0;
    } else {
      currentTypeID++;
    }
    notifyListeners();
  }
}
