import 'package:flutter/foundation.dart';
import 'package:lecture_performance_app/db/models/seat.dart';
import 'package:lecture_performance_app/db/models/student.dart';
import 'package:lecture_performance_app/services/seat_service.dart';
import 'package:lecture_performance_app/services/student_service.dart';
import 'package:lecture_performance_app/utility/seat_view_func.dart';

class SeatEditPosProvider with ChangeNotifier {
  SeatEditPosProvider({
    @required SeatService seat,
    @required StudentService student,
    @required int homeroomID,
  })  : _seat = seat,
        _homeroomID = homeroomID,
        _student = student {
    update();
  }

  final SeatService _seat;
  final StudentService _student;
  final int _homeroomID;

  List<Seat> _list = [];
  List<Seat> get list => _list == null ? [] : List.unmodifiable(_list);

  List<Student> _students = [];
  List<Student> get students =>
      _students == null ? [] : List.unmodifiable(_students);

//  初期値は仮に7とおいている
  int _width = 7;
  int get width => _width;

//  何も指定されていないときは-1それ以外はstudent.idが
//  保存されている
  int targetStudentID = -1;

  void targetSeat(int id) {
    print(id);
    print(targetStudentID);
    if (targetStudentID == -1) {
      targetStudentID = id;
    } else {
      _student.changePositionNum(id, targetStudentID).then((value) {
        targetStudentID = -1;
        update();
      });
    }
  }

  void update() {
    _seat.getThisRoomAllSeatData(_homeroomID).then((value) {
      final data = calcSeatLen(value);
      _list = data.seat;
      _width = data.width;
      _student.getRoomStudentsByPos(_homeroomID).then((value) {
        _students = value;
        notifyListeners();
      });
    });
  }
}
