import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/snackBar/common_snack_bar.dart';
import 'package:lecture_performance_app/db/models/seat.dart';
import 'package:lecture_performance_app/db/models/student.dart';
import 'package:lecture_performance_app/services/evaluation_service.dart';
import 'package:lecture_performance_app/services/seat_service.dart';
import 'package:lecture_performance_app/services/student_evaluation_service.dart';
import 'package:lecture_performance_app/utility/seat_view_func.dart';
import 'package:stack/stack.dart' as Stack;

class HomeRoomShowProvider with ChangeNotifier {
  HomeRoomShowProvider({
    @required StudentWithEvaluationService student,
    @required SeatService seat,
    @required EvaluationService evaluation,
    @required int homeroomID,
  })  : _student = student,
        _seat = seat,
        _evaluation = evaluation,
        _homeroomID = homeroomID {
    update();
  }

  final SeatService _seat;
  final StudentWithEvaluationService _student;
  final EvaluationService _evaluation;
  final int _homeroomID;

  List<Seat> _list = [];
  List<Seat> get list => _list == null ? [] : List.unmodifiable(_list);

  List<Student> _students = [];
  List<Student> get students =>
      _students == null ? [] : List.unmodifiable(_students);

  ///  初期値は仮に7とおいている
  int _width = 7;
  int get width => _width;

  ///  バッジの表示用のデータ
  final List<DisplayBadge> _seatBadge = [];
  List<DisplayBadge> get seatBadge => _seatBadge;

  ///  スワイプ移動距離の測定用
  int currentTypeID = 1;
  double x = 0;
  double y = 0;

  ///  使用コマンド一覧
  Stack.Stack<Command> sta = Stack.Stack();

  void position(double dx, double dy) {
    x = dx;
    y = dy;
    notifyListeners();
  }

  /// 成績をつけた際のバッジ
  void badgeChange(int index, Color color, String text) {
    _seatBadge[index].isShow = !_seatBadge[index].isShow;
    _seatBadge[index].color = color;
    _seatBadge[index].text = text;
    Future<void>.delayed(const Duration(seconds: 2)).then((value) {
      _seatBadge[index].isShow = !_seatBadge[index].isShow;
      notifyListeners();
    });
  }

  void evaluation(
    int studentID,
    int typeID,
    int point,
    int index,
  ) {
    Command c;
    c = Command(-1, '', -1, null, point)
      ..indexNum = index
      ..time = _students[index].lastTime
      ..student = _students[index];
    _evaluation.createEvaluation(studentID, typeID, point).then((value) {
      update();
      print(value);
      c.evaID = value;
      sta.push(c);
      notifyListeners();
    });
  }

  void undo(BuildContext context) {
    if (sta.isNotEmpty) {
      Command c;
      c = sta.top();
      sta.pop();
      _students[c.indexNum].lastTime = c.time;
      _evaluation.deleteEvaluation(c.evaID).then((value) {
        notifyListeners();
        Scaffold.of(context).showSnackBar(
          commonSnackBar(
            '取り消しました',
            Colors.yellowAccent,
            28,
          ),
        );
      });
    }
  }

  void update() {
    _seat.getThisRoomAllSeatData(_homeroomID).then((value) {
      final data = calcSeatLen(value);
      _list = data.seat;
      _width = data.width;
      _student.getRoomStudents(_homeroomID).then((value) {
        _students = value;
        if (_seatBadge.isEmpty) {
          for (var i = 0; i < _list.length; i++) {
            final s =
                DisplayBadge(isShow: false, color: Colors.red, text: 'non');
            _seatBadge.add(s);
          }
        }
        notifyListeners();
      });
    });
  }
}

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
