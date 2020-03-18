import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/Evaluation.dart';
import 'package:lecture_performance_app/db/models/EvaluationType.dart';
import 'package:lecture_performance_app/db/models/Student.dart';
import 'package:lecture_performance_app/services/Evaluation.dart';
import 'package:lecture_performance_app/services/EvaluationType.dart';
import 'package:lecture_performance_app/services/Student.dart';
import 'package:lecture_performance_app/wire.dart';

class StudentProvider with ChangeNotifier {
  StudentProvider(int studentID) {
    _evaluationService = initEvaluationAPI();
    _evaluationTypeService = initEvaluationTypeAPI();
    _studentService = initStudentAPI();
    getAllEvaluationType();
    getStudent(studentID);
    getStudentEvaluation(studentID);
    notifyListeners();
  }

  StudentService _studentService;
  EvaluationService _evaluationService;
  EvaluationTypeService _evaluationTypeService;
  List<EvaluationType> _evaluationSelect;
  List<EvaluationType> get getEvaluationSelect => _evaluationSelect;
  Student _student;
  Student get student => _student;
  List<Evaluation> _eval;
  List<Evaluation> get eval => _eval;

  void getAllEvaluationType() async {
    await _evaluationTypeService
        .getAllEvaluationType()
        .then((res) => (_evaluationSelect = res));
    notifyListeners();
  }

  void evaluation(int studentID, int typeID, int point) async {
    await _evaluationService.createEvaluation(studentID, typeID, point);
    notifyListeners();
  }

  void getStudent(int studentID) async {
    await _studentService.getStudent(studentID).then((res) => (_student = res));
    notifyListeners();
  }

  void getStudentEvaluation(int studentID) async {
    await _evaluationService
        .getStudentSemester(studentID)
        .then((res) => (_eval = res));
    notifyListeners();
  }
}
