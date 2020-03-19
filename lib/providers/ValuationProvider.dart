import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/EvaluationType.dart';
import 'package:lecture_performance_app/services/Evaluation.dart';
import 'package:lecture_performance_app/services/EvaluationType.dart';
import 'package:lecture_performance_app/wire.dart';

class EvaluationProvider with ChangeNotifier {
  EvaluationService _evaluationService;
  EvaluationTypeService _evaluationTypeService;
  int currentTypeID;
  double x = 0.0;
  double y = 0.0;

  void position(dx, dy) {
    x = dx;
    y = dy;
    notifyListeners();
  }

  List<EvaluationType> _evaluationSelect;
  List<EvaluationType> get getEvaluationSelect => _evaluationSelect;
  EvaluationProvider() {
    _evaluationService = initEvaluationAPI();
    _evaluationTypeService = initEvaluationTypeAPI();
    getAllEvaluationType();
    notifyListeners();
  }

  void getAllEvaluationType() async {
    await _evaluationTypeService
        .getAllEvaluationType()
        .then((res) => (_evaluationSelect = res));
    currentTypeID = _evaluationSelect[0].id - 1;
    notifyListeners();
  }

  void changeTypeLeft() {
    if(currentTypeID!=0) {
      currentTypeID--;
    } else {
      currentTypeID = _evaluationSelect.length-1;
    }
    notifyListeners();
  }

  void changeTypeRight() {
    if(currentTypeID==_evaluationSelect.length-1) {
      currentTypeID=0;
    } else {
      currentTypeID++;
    }
    notifyListeners();
  }
  
  void evaluation(int studentID, int typeID, int point) async {
    await _evaluationService.createEvaluation(studentID, typeID, point);
    notifyListeners();
  }
}
