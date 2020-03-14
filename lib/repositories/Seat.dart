import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../db/models/Seat.dart';

class SeatRepository {
  final Database db;

  SeatRepository({this.db});

  Future<Seat> getseat(int id) async {
    final List<Map<String, dynamic>> res =
        await db.query("seat", where: "id = ?", whereArgs: [id], limit: 1);
    List<Seat> list =
        res.isNotEmpty ? res.map((c) => Seat.fromMap(c)).toList() : [];
    return list[0];
  }

  Future<List<Seat>> getAllseats() async {
    final List<Map<String, dynamic>> res = await db.query('seat');
    List<Seat> list =
        res.isNotEmpty ? res.map((c) => Seat.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> insertSeat(Seat seat) async {
    var id = await db.insert(
      'seat',
      seat.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<List<Seat>> getThisRoomSeats(int homeRoomID) async {
    final List<Map<String, dynamic>> res = await db
        .query("seat", where: "homeroom_id = ?", whereArgs: [homeRoomID], limit: 64);
    List<Seat> list =
        res.isNotEmpty ? res.map((c) => Seat.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> updateseat(Seat seat) async {
    await db.update(
      'seat',
      seat.toMapNew(),
      where: "id = ?",
      whereArgs: [seat.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
