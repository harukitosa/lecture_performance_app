import 'package:lecture_performance_app/services/HomeRoom.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:sqflite/sqlite_api.dart';

HomeRoomService initHomeRoomAPI(Database db) {
  var _homeRoomRepository = new HomeRoomRepository(db: db);
  var _homeRoomService = new HomeRoomService(homeRoomRepository: _homeRoomRepository);
  return _homeRoomService;
}

