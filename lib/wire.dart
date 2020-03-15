import 'package:lecture_performance_app/repositories/Seat.dart';
import 'package:lecture_performance_app/services/HomeRoom.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:lecture_performance_app/services/Seat.dart';

HomeRoomService initHomeRoomAPI() {
  var _homeRoomRepository = new HomeRoomRepository();
  var _homeRoomService =
      new HomeRoomService(homeRoomRepository: _homeRoomRepository);
  return _homeRoomService;
}

SeatService initSeatAPI() {
  var _seatRepository = new SeatRepository();
  var _seatService = new SeatService(seatRepository: _seatRepository);
  return _seatService;
}
