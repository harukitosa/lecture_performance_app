import 'package:lecture_performance_app/services/HomeRoom.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';

HomeRoomService initHomeRoomAPI() {
  var _homeRoomRepository = new HomeRoomRepository();
  var _homeRoomService = new HomeRoomService(homeRoomRepository: _homeRoomRepository);
  return _homeRoomService;
}

