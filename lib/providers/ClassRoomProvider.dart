import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/Seat.dart';
import 'package:lecture_performance_app/services/Seat.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:lecture_performance_app/utility/seatFunc.dart';

class ClassRoomProvider with ChangeNotifier {
  List<Seat> _mapSeat;
  List<Seat> _viewSeat;
  int _viewWidth;
  SeatService _seatService;

  List<Seat> get mapSeat => _mapSeat;
  List<Seat> get viewSeat => _viewSeat;
  int get viewWidth => _viewWidth;

  ClassRoomProvider(int homeRoomID) {
    _seatService = initSeatAPI();
    getSeatData(homeRoomID);
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
}
