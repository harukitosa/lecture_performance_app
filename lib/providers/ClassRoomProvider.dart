import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/Seat.dart';
import 'package:lecture_performance_app/db/models/Student.dart';
import 'package:lecture_performance_app/services/evaluation_service.dart';
import 'package:lecture_performance_app/services/seat_service.dart';
import 'package:lecture_performance_app/services/student_evaluation_service.dart';
import 'package:lecture_performance_app/services/student_service.dart';
import 'package:lecture_performance_app/common/snackBar/commonSnackBar.dart';
import 'package:lecture_performance_app/utility/time.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:lecture_performance_app/utility/seatFunc.dart';
import 'dart:async';
import 'package:stack/stack.dart' as Col;
import 'dart:collection';

class DisplayBadge {
  DisplayBadge({this.isShow, this.text, this.color});

  bool isShow;
  String text;
  Color color;
}

class Command {
  Command(
    this.evaID,
    this.time,
    this.indexNum,
    this.student,
    this.point,
  );
  int evaID;
  String time;
  int indexNum;
  Student student;
  int point;
}

class ClassRoomProvider with ChangeNotifier {
  ClassRoomProvider(int homeRoomID) {
    _seatService = initSeatAPI();
    _studentService = initStudentAPI();
    _sweService = initStudentWithEvaluationServiceAPI();
    _evaluationService = initEvaluationAPI();
    getSeatData(homeRoomID);
    getStudentData(homeRoomID);
  }

  List<Seat> _mapSeat = [];
  List<Seat> get mapSeat => _mapSeat;

  List<Seat> _viewSeat = [];
  List<Seat> get viewSeat => _viewSeat;
  final List<DisplayBadge> _seatBadge = [];
  List<DisplayBadge> get seatBadge => _seatBadge;

  List<Student> _studentList = [];
  List<Student> get studentList => _studentList;

  bool _sort = false;
  bool get sort => _sort;

  /// _seatArrange records index number
  int _seatArrange = -1;
  int get seatArrange => _seatArrange;

  /// _viewWidth records display seat width
  int _viewWidth;
  int get viewWidth => _viewWidth;

  Col.Stack<Command> sta = Col.Stack();

  SeatService _seatService;
  StudentService _studentService;
  EvaluationService _evaluationService;
  StudentWithEvaluationService _sweService;

  void sortChange() {
    _sort = !_sort;
    notifyListeners();
  }

  Future<void> evaluation(
      int studentID, int typeID, int point, int index) async {
    // 一致確認
    Command c;
    c = Command(-1, '', -1, null, point);
    if (_studentList[index].id == studentID) {
      c
        ..indexNum = index
        ..time = _studentList[index].lastTime;
      _studentList[index].lastTime = getNowTime();
      c.student = _studentList[index];
    }
    final id =
        await _evaluationService.createEvaluation(studentID, typeID, point);
    c.evaID = id;
    sta.push(c);
    notifyListeners();
  }

  Future<void> undo(BuildContext context) async {
    if (sta.isNotEmpty) {
      Command c;
      c = sta.top();
      sta.pop();
      _studentList[c.indexNum].lastTime = c.time;
      await _evaluationService.deleteEvaluation(c.evaID);
      notifyListeners();
      Scaffold.of(context).showSnackBar(
        commonSnackBar(
          '取り消しました',
          Colors.yellowAccent,
          28,
        ),
      );
    }
  }

  /// 成績をつけた際のバッジ
  Future<void> badgeChange(int index, Color color, String text) async {
    _seatBadge[index].isShow = !_seatBadge[index].isShow;
    _seatBadge[index].color = color;
    _seatBadge[index].text = text;
    await Future<dynamic>.delayed(const Duration(seconds: 2));
    _seatBadge[index].isShow = !_seatBadge[index].isShow;
  }

  /// 席替えの時に使用
  void seatArrangePointer(int index) {
    print('seatArrangePointer');
    if (_seatArrange != -1) {
      final firstID = studentList[index].id;
      final secondID = studentList[_seatArrange].id;
      _studentService.changePositionNum(firstID, secondID);
      final store = studentList[index];
      studentList[index] = studentList[_seatArrange];
      studentList[_seatArrange] = store;
      _seatArrange = -1;
      notifyListeners();
    } else {
      _seatArrange = index;
      notifyListeners();
    }
  }

  void onSortColum(int columnIndex, {bool ascending}) {
    if (columnIndex == 0) {
      if (ascending) {
        _studentList.sort((a, b) => a.number.compareTo(b.number));
      } else {
        _studentList.sort((a, b) => b.number.compareTo(a.number));
      }
    }
  }

  void getSeatData(int homeRoomID) {
    _seatService.getThisRoomAllSeatData(homeRoomID).then(
      (res) {
        // 7*7の列
        _mapSeat = res;
        // 表示するシートのみ
        final ans = calcSeatLen(_mapSeat);
        _viewSeat = ans.seat;
        _viewWidth = ans.width;
        if (_seatBadge.isNotEmpty) {
          for (var i = 0; i < _viewSeat.length; i++) {
            DisplayBadge s;
            s = DisplayBadge(isShow: false, color: Colors.red, text: 'non');
            _seatBadge.add(s);
          }
        }
        notifyListeners();
      },
    );
  }

  Future<void> getStudentData(int homeRoomID) async {
    print('getStudentData');
    await _sweService.getRoomStudents(homeRoomID).then((res) {
      _studentList = res;
      notifyListeners();
    });
    _studentList.sort((a, b) => a.positionNum.compareTo(b.positionNum));
  }

  Future<void> registStudentData(
    int homeRoomID,
    int number,
    String firstName,
    String lastName,
  ) async {
    await _studentService.createstudent(
      homeRoomID,
      firstName,
      lastName,
      number,
    );
    notifyListeners();
  }
}
