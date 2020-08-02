import 'package:flutter/foundation.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/db/models/homeroom.dart';
import 'package:lecture_performance_app/services/homeroom_service.dart';
import 'package:lecture_performance_app/services/seat_service.dart';

class HomeRoomProvider with ChangeNotifier {
  HomeRoomProvider(
      {@required HomeRoomService homeroom, @required SeatService seat})
      : _homeRoom = homeroom,
        _seat = seat {
    for (var i = 0; i < config.seatNum; i++) {
      _newHomeRoomSeat.add('true');
    }
    _updateList();
  }

  final HomeRoomService _homeRoom;
  final SeatService _seat;

  List<HomeRoom> _list;
  List<HomeRoom> get list => _list == null ? [] : List.unmodifiable(_list);
  AppDataConfig config = AppDataConfig();
  final List<String> _newHomeRoomSeat = [];
  List<String> get newHomeRoomSeat =>
      _newHomeRoomSeat == null ? [] : List.unmodifiable(_newHomeRoomSeat);

  Future<void> saveHomeRoom(
    String grade,
    String lectureClass,
  ) async {
    final homeroomID = await _homeRoom.createHomeRoom(grade, lectureClass);
    for (var i = 0; i < config.seatNum; i++) {
      await _seat.insertSeatData(homeroomID, _newHomeRoomSeat[i]);
      _newHomeRoomSeat[i] = 'true';
    }
    _updateList();
  }

  Future<void> deleteHomeRoom(
    int id,
  ) async {
    await _homeRoom.deleteHomeRoom(id);
    _updateList();
  }

  /// _newHomeRoomSeat
  void changeSeatState(int id) {
    final value = _newHomeRoomSeat[id];
    if (value == 'true') {
      _newHomeRoomSeat[id] = 'false';
    } else {
      _newHomeRoomSeat[id] = 'true';
    }
    notifyListeners();
  }

  void _updateList() {
    _homeRoom.getAllHomeRoom().then((value) {
      _list = value;
      notifyListeners();
    });
  }
}
