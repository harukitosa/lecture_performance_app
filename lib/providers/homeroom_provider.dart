import 'package:flutter/foundation.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/services/homeroom_service.dart';

class HomeRoomProvider with ChangeNotifier {
  HomeRoomProvider({@required HomeRoomService homeroom}) : _homeRoom = homeroom;

  final HomeRoomService _homeRoom;

  List<HomeRoom> _list;

  void _updateList() {
    _homeRoom.getAllHomeRoom().then((value) {
      _list = value;
      notifyListeners();
    });
  }
}
