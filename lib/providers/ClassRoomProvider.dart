import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/Seat.dart';
import 'package:lecture_performance_app/db/models/Student.dart';
import 'package:lecture_performance_app/services/Evaluation.dart';
import 'package:lecture_performance_app/services/EvaluationType.dart';
import 'package:lecture_performance_app/services/Seat.dart';
import 'package:lecture_performance_app/services/Student.dart';
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

  /// ↓に移動させたい
  List<StudentInfo> _studentInfo = [];
  List<StudentInfo> get studentInfo => _studentInfo;

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
  EvaluationService _evaluationService;

  ClassRoomProvider(int homeRoomID) {
    _seatService = initSeatAPI();
    _studentService = initStudentAPI();
    _evaluationService = initEvaluationAPI();
    getSeatData(homeRoomID);
    getStudentData(homeRoomID);
    notifyListeners();
  }

  void sortChange() {
    _sort = !_sort;
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
  /// serviceに移す
  void seatArrangePointer(int index) {
    if (_seatArrange != -1) {
      var a = new Student(
        id: studentList[index].id,
        firstName: studentList[index].firstName,
        lastName: studentList[index].lastName,
        createTime: studentList[index].createTime,
        number: studentList[index].number,
        positionNum: studentList[_seatArrange].positionNum,
        homeRoomID: studentList[index].homeRoomID,
      );

      var b = new Student(
        id: studentList[_seatArrange].id,
        firstName: studentList[_seatArrange].firstName,
        lastName: studentList[_seatArrange].lastName,
        createTime: studentList[_seatArrange].createTime,
        number: studentList[_seatArrange].number,
        positionNum: studentList[index].positionNum,
        homeRoomID: studentList[_seatArrange].homeRoomID,
      );

      _studentList[index].positionNum = a.positionNum;
      _studentList[_seatArrange].positionNum = b.positionNum;
      notifyListeners();
      _studentService.editstudent(
        a.id,
        a.homeRoomID,
        a.positionNum,
        a.firstName,
        a.lastName,
        a.number,
        a.createTime,
      );

      _studentService.editstudent(
        b.id,
        b.homeRoomID,
        b.positionNum,
        b.firstName,
        b.lastName,
        b.number,
        b.createTime,
      );
      _seatArrange = -1;
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
    await _studentService.getRoomStudents(homeRoomID).then((res) {
      _studentList = res;
    });
    _studentList.sort((a, b) => a.positionNum.compareTo(b.positionNum));
    notifyListeners();
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
