import 'package:flutter/foundation.dart';
import 'package:lecture_performance_app/db/models/seat.dart';
import 'package:lecture_performance_app/services/seat_service.dart';

class SeatEditProvider with ChangeNotifier {
  SeatEditProvider({
    @required SeatService seat,
    @required int homeroomID,
  })  : _seat = seat,
        _homeroomID = homeroomID {
    update();
  }

  final SeatService _seat;
  final int _homeroomID;

  List<Seat> _list = [];
  List<Seat> get list => _list == null ? [] : List.unmodifiable(_list);

  void seatUpdate(int id, String used, String createTime) {
    _seat.updateSeatData(id, _homeroomID, used, createTime).then((value) {
      update();
    });
  }

  void update() {
    _seat.getThisRoomAllSeatData(_homeroomID).then((value) {
      _list = value;
      notifyListeners();
    });
  }
}
