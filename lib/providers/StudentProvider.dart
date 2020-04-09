import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/Evaluation.dart';
import 'package:lecture_performance_app/db/models/EvaluationType.dart';
import 'package:lecture_performance_app/db/models/Student.dart';
import 'package:lecture_performance_app/services/evaluation_service.dart';
import 'package:lecture_performance_app/services/evaluation_type_service.dart';
import 'package:lecture_performance_app/services/student_service.dart';
import 'package:lecture_performance_app/wire.dart';

class StudentProvider with ChangeNotifier {
  StudentProvider(int studentID) {
    _evaluationService = initEvaluationAPI();
    _evaluationTypeService = initEvaluationTypeAPI();
    _studentService = initStudentAPI();
    getAllEvaluationType();
    getStudent(studentID);
    getLatest(studentID);
    getStudentEvaluation(studentID);
    getEvaluationSum(studentID);
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
  List<Evaluation> _latest;
  List<Evaluation> get latest => _latest;
  List<SumEvaluationType> _sumList;
  List<SumEvaluationType> get sumList => _sumList;

// 生徒編集用の変数
  String _firstName = "";
  String get firstName => _firstName;
  set setFirstName(String firstName) => _firstName = firstName;
  // 生徒編集用の変数
  String _lastName = "";
  String get lastName => _lastName;
  set setLastName(String lastName) => _lastName = lastName;
// 生徒編集用の変数
  String _number = "";
  String get number => _number;
  set setNumber(String number) => _number = number;

  void handleChangeFirstName(String e) {
    _firstName = e;
    notifyListeners();
  }

  void handleChangeLastName(String e) {
    _lastName = e;
    notifyListeners();
  }

  void handleChangeNum(String e) {
    _number = e;
    notifyListeners();
  }

  void updateStudent() async {
    int _n;
    bool err = false;
    try {
      _n = int.parse(number.toString());
    } catch (exception) {
      _n = 0;
      err = true;
    }
    if (!err) {
      await _studentService.editstudent(
        student.id,
        student.homeRoomID,
        student.positionNum,
        _firstName,
        _lastName,
        _n,
        student.createTime,
      );
    }
    notifyListeners();
  }

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
    setFirstName = _student.firstName;
    setLastName = _student.lastName;
    setNumber = _student.number.toString();
    notifyListeners();
  }

  void getLatest(int studentID) async {
    await _evaluationService
        .getLatestStudent(studentID)
        .then((res) => (_latest = res));
    notifyListeners();
  }

  void getStudentEvaluation(int studentID) async {
    await _evaluationService
        .getStudentSemester(studentID)
        .then((res) => (_eval = res));
    notifyListeners();
  }

  void getEvaluationSum(int studentID) async {
    await _evaluationTypeService
        .getEvaluationSum(studentID)
        .then((res) => (_sumList = res));
    notifyListeners();
  }
}
