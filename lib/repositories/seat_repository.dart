import 'dart:async';

import 'package:lecture_performance_app/db/models/seat.dart';

abstract class ISeatRepository {
  Future<Seat> getseat(int id);
  Future<List<Seat>> getAllseats();
  Future<int> insertSeat(Seat seat);
  Future<List<Seat>> getThisRoomSeats(int homeRoomID);
  Future<void> updateseat(Seat seat);
}
