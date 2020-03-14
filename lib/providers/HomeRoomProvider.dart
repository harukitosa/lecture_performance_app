import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/services/HomeRoom.dart';
import 'package:lecture_performance_app/wire.dart';
class HomeRoomProvider with ChangeNotifier {
  List<HomeRoom> _homeRoom = [];
  List<HomeRoom> get homeRoom => _homeRoom;
  HomeRoomService _homeRoomService;
  HomeRoomProvider() {
    _homeRoomService = initHomeRoomAPI();
    getAllHomeRoom();
  }

  void getAllHomeRoom() async {
    await _homeRoomService.getAllHomeRoom().then((res)=>(_homeRoom = res));
    notifyListeners();
  }
}