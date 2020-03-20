import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/Seat.dart';
import 'package:lecture_performance_app/db/models/Student.dart';
import 'package:lecture_performance_app/services/Seat.dart';
import 'package:lecture_performance_app/services/Student.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:lecture_performance_app/utility/seatFunc.dart';

class ClassRoomProvider with ChangeNotifier {
  List<Seat> _mapSeat;
  List<Seat> _viewSeat;
  List<Student> _studentList;
  int _viewWidth;
  SeatService _seatService;
  StudentService _studentService;

  List<Student> get studentList => _studentList;
  List<Seat> get mapSeat => _mapSeat;
  List<Seat> get viewSeat => _viewSeat;

  int get viewWidth => _viewWidth;

  bool _sort = false;
  bool get sort => _sort;

  void sortChange() {
    _sort = !_sort;
    notifyListeners();
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        _studentList.sort((a, b) => a.number.compareTo(b.number));
      } else {
        _studentList.sort((a, b) => b.number.compareTo(a.number));
      }
    }
  }

  ClassRoomProvider(int homeRoomID) {
    _seatService = initSeatAPI();
    _studentService = initStudentAPI();
    getSeatData(homeRoomID);
    getStudentData(homeRoomID);
    notifyListeners();
  }

  void getSeatData(homeRoomID) async {
    await _seatService.getThisRoomAllSeatData(homeRoomID).then(
      (res) {
        _mapSeat = res;
        var ans = calcSeatLen(_mapSeat);
        _viewSeat = ans.seat;
        _viewWidth = ans.width;
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

  void registStudentData(int homeRoomID, int number, String name) async {
    await _studentService.createstudent(homeRoomID, name, number);
    notifyListeners();
  }
}
