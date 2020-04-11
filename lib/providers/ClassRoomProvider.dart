import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/Seat.dart';
import 'package:lecture_performance_app/db/models/Student.dart';
import 'package:lecture_performance_app/services/seat_service.dart';
import 'package:lecture_performance_app/services/student_evaluation_service.dart';
import 'package:lecture_performance_app/services/student_service.dart';
import 'package:lecture_performance_app/utility/time.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:lecture_performance_app/utility/seatFunc.dart';
import 'dart:async';
import 'dart:collection';

class DisplayBadge {
  bool isShow;
  String text;
  Color color;
  DisplayBadge({this.isShow, this.text, this.color});
}

class StudentInfo {
  Student student;
  int sumPoint;
  StudentInfo({this.student, this.sumPoint});
}

class ClassRoomProvider with ChangeNotifier {
  List<Seat> _mapSeat = [];
  List<Seat> get mapSeat => _mapSeat;

  List<Seat> _viewSeat = [];
  List<Seat> get viewSeat => _viewSeat;
  List<DisplayBadge> _seatBadge = [];
  List<DisplayBadge> get seatBadge => _seatBadge;

  List<Student> _studentList = [];
  List<Student> get studentList => _studentList;

  var _studentVal = HashMap();
  get studentVal => _studentVal;

  bool _sort = false;
  bool get sort => _sort;

  /// _seatArrange records index number
  int _seatArrange = -1;
  int get seatArrange => _seatArrange;

  /// _viewWidth records display seat width
  int _viewWidth;
  int get viewWidth => _viewWidth;

  SeatService _seatService;
  StudentService _studentService;
  // EvaluationService _evaluationService;

  StudentWithEvaluationService _sweService;


  ClassRoomProvider(int homeRoomID) {
    _seatService = initSeatAPI();
    _studentService = initStudentAPI();
    _sweService = initStudentWithEvaluationServiceAPI();
    getSeatData(homeRoomID);
    getStudentData(homeRoomID);
  }

  void sortChange() {
    _sort = !_sort;
    notifyListeners();
  }

  void timeUpdate(index) async {
    _studentList[index].lastTime = getNowTime();
    notifyListeners();
  }

  /// 成績をつけた際のバッジ
  void badgeChange(index, color, text) async {
    _seatBadge[index].isShow = !_seatBadge[index].isShow;
    _seatBadge[index].color = color;
    _seatBadge[index].text = text;
    await new Future.delayed(new Duration(seconds: 1));
    _seatBadge[index].isShow = !_seatBadge[index].isShow;
  }

  /// 席替えの時に使用
  void seatArrangePointer(int index) {
    print('seatArrangePointer');
    if (_seatArrange != -1) {
      int firstID = studentList[index].id;
      int secondID = studentList[_seatArrange].id;
      _studentService.changePositionNum(firstID, secondID);
      var store = studentList[index];
      studentList[index] = studentList[_seatArrange];
      studentList[_seatArrange] = store;
      _seatArrange = -1;
      notifyListeners();
    } else {
      _seatArrange = index;
      notifyListeners();
    }
  }

  void onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        _studentList.sort((a, b) => a.number.compareTo(b.number));
      } else {
        _studentList.sort((a, b) => b.number.compareTo(a.number));
      }
    }
  }

  void getSeatData(homeRoomID) async {
    await _seatService.getThisRoomAllSeatData(homeRoomID).then(
      (res) {
        // 7*7の列
        _mapSeat = res;
        // 表示するシートのみ
        var ans = calcSeatLen(_mapSeat);
        _viewSeat = ans.seat;
        _viewWidth = ans.width;
        if (_seatBadge != []) {
          for (var i = 0; i < _viewSeat.length; i++) {
            DisplayBadge s =
                new DisplayBadge(isShow: false, color: Colors.red, text: "non");
            _seatBadge.add(s);
          }
        }
      },
    );
    notifyListeners();
  }

  void getStudentData(homeRoomID) async {
    print("getStudentData");
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
