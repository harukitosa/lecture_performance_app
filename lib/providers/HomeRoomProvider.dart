import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/db/models/Seat.dart';
import 'package:lecture_performance_app/services/HomeRoom.dart';
import 'package:lecture_performance_app/services/Seat.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';

class HomeRoomProvider with ChangeNotifier {
  List<HomeRoom> _homeRoom = [];
  List<String> _mapSeat = [];
  List<Seat> _currentSeat = [];
  HomeRoomService _homeRoomService;

  SeatService _seatService;
  var config = AppDataConfig();

  List<HomeRoom> get homeRoom => _homeRoom;
  List<String> get mapSeat => _mapSeat;
  List<Seat> get currentSeat => _currentSeat;

  HomeRoomProvider() {
    _homeRoomService = initHomeRoomAPI();
    _seatService = initSeatAPI();

    getAllHomeRoom();
    for (var i = 0; i < config.seatNum; i++) {
      _mapSeat.add("true");
    }
    notifyListeners();
  }

  void getAllHomeRoom() async {
    await _homeRoomService.getAllHomeRoom().then((res) => (_homeRoom = res));
    notifyListeners();
  }

  void getSeatData(int id) async {
    await _seatService
        .getThisRoomAllSeatData(id)
        .then((res) => (_currentSeat = res));
    notifyListeners();
  }

  /// HomeRoomの登録
  /// todo: service層に処理を移す
  void registHomeRoom(
    String grade,
    String lectureClass,
    List<String> seatData,
  ) async {
    var homeroomID = await _homeRoomService.createHomeRoom(grade, lectureClass);
    for (var i = 0; i < config.seatNum; i++) {
      await _seatService.insertSeatData(homeroomID, seatData[i]);
    }
    notifyListeners();
  }

  /// 新規登録の際に使用する
  void changeSeatState(int id) {
    var value = _mapSeat[id];
    if (value == "true") {
      _mapSeat[id] = "false";
    } else {
      _mapSeat[id] = "true";
    }
    notifyListeners();
  }

  /// 座席の数編集
  void editSeatState(int index) {
    var cs = currentSeat[index];
    String flag = "false";
    if (cs.used == "true") {
      flag = "false";
    } else {
      flag = "true";
    }
    var seat = new Seat(
      id: cs.id,
      homeRoomID: cs.homeRoomID,
      used: flag,
      createTime: cs.createTime,
      updateTime: cs.updateTime,
    );
    _currentSeat[index] = seat;
    _seatService.updateSeatData(
      cs.id,
      cs.homeRoomID,
      flag,
      cs.createTime,
    );
    notifyListeners();
  }
}
