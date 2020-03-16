import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/services/HomeRoom.dart';
import 'package:lecture_performance_app/services/Seat.dart';
import 'package:lecture_performance_app/wire.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/services/Semester.dart';

class HomeRoomProvider with ChangeNotifier {
  List<HomeRoom> _homeRoom = [];
  List<String> _mapSeat = [];
  HomeRoomService _homeRoomService;
  SemesterService _semesterService;
  SeatService _seatService;
  var config = AppDataConfig();

  List<HomeRoom> get homeRoom => _homeRoom;
  List<String> get mapSeat => _mapSeat;

  HomeRoomProvider() {
    _homeRoomService = initHomeRoomAPI();
    _seatService = initSeatAPI();
    _semesterService = initSemesterAPI();
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

//todo: service層に処理を移す
  void registHomeRoom(String grade, String lectureClass, List<String> seatData) async {
    var homeroomID = await _homeRoomService.createHomeRoom(grade, lectureClass);
    for (var i = 0; i < config.seatNum; i++) {
      await _seatService.insertSeatData(homeroomID, seatData[i]);
    }
    await _semesterService.createsemester("一学期", homeroomID);
    notifyListeners();
  }

  void changeSeatState(int id) {
    var value = _mapSeat[id];
    if (value == "true") {
      _mapSeat[id] = "false";
    } else {
      _mapSeat[id] = "true";
    }
    notifyListeners();
  }
}
