import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/common/snackBar/common_snack_bar.dart';
import 'package:lecture_performance_app/db/models/seat.dart';
import 'package:lecture_performance_app/db/models/student.dart';
import 'package:lecture_performance_app/services/evaluation_service.dart';
import 'package:lecture_performance_app/services/seat_service.dart';
import 'package:lecture_performance_app/services/student_evaluation_service.dart';
import 'package:lecture_performance_app/utility/seat_view_func.dart';
// import 'package:stack/stack.dart' as Stack;
import 'dart:collection';

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

  /// 成績をつけた回数
  Map<int, int> studentScoreSum = <int, int>{};

  ///  初期値は仮に7とおいている
  int _width = 7;
  int get width => _width;

  ///  バッジの表示用のデータ
  final List<DisplayBadge> _seatBadge = [];
  List<DisplayBadge> get seatBadge =>
      _seatBadge == null ? [] : List.unmodifiable(_seatBadge);

  ///  スワイプ移動距離の測定用
  int currentTypeID = 1;
  double x = 0;
  double y = 0;

  ///  使用コマンド一覧
  ListQueue<Command> sta = ListQueue.from([]);

  List<String> get undoStudent {
    if (sta == null) {
      return [];
    }
    final _list = sta.toList();
    final _value = <String>[];
    _list.forEach((item) {});
    for (var i = _list.length - 3; i < _list.length; i++) {
      if (i >= 0) {
        _value.add(
          _list[i].student.firstName + ' ' + _list[i].student.lastName,
        );
      }
    }
    return _value;
  }

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

    /// 一つ前の成績をつけた生徒と同一であれば前回のをまとめる
    if (sta.isNotEmpty && sta.last.student.id == studentID) {
      _evaluation.getEvaluation(sta.last.evaID).then((value) {
        _evaluation
            .editEvaluation(
          value.id,
          value.studentID,
          value.typeID,
          value.point + point,
          value.createTime,
        )
            .then((value) {
          update();
        });
      });
    } else {
      _evaluation.createEvaluation(studentID, typeID, point).then((value) {
        c.evaID = value;
        // sta.add(c);
        sta.add(c);
        update();
      });
    }
  }

  void undo(BuildContext context) {
    if (sta.isNotEmpty) {
      Command c;
      c = sta.last;
      sta.removeLast();
      _students[c.indexNum].lastTime = c.time;
      _evaluation.deleteEvaluation(c.evaID).then((value) {
        Scaffold.of(context).showSnackBar(
          commonSnackBar(
            '取り消しました',
            Colors.yellowAccent,
            28,
          ),
        );
        update();
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
        for (final item in _students) {
          _evaluation.getStudentCount(item.id).then((value) {
            studentScoreSum[item.id] = value;
            notifyListeners();
          });
        }
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
