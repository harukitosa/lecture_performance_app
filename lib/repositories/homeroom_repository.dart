import 'dart:async';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';

abstract class IHomeRoomRepository {
  Future<int> insertHomeRoom(HomeRoom homeRoom);
  Future<List<HomeRoom>> getHomeRooms();
  Future<void> deleteHomeRoom(int id);
  Future<void> updateHomeRoom(HomeRoom homeRoom);
}


