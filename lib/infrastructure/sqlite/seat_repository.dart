import 'package:lecture_performance_app/db/models/Seat.dart';
import 'package:lecture_performance_app/repositories/seat_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

ISeatRepository newSeatRepository() {
  return new SeatRepository();
}

class SeatRepository extends ISeatRepository {
  SeatRepository();

  Future<Seat> getseat(int id) async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res =
        await db.query("seat", where: "id = ?", whereArgs: [id], limit: 1);
    List<Seat> list =
        res.isNotEmpty ? res.map((c) => Seat.fromMap(c)).toList() : [];
    return list[0];
  }

  Future<List<Seat>> getAllseats() async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query('seat');
    List<Seat> list =
        res.isNotEmpty ? res.map((c) => Seat.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> insertSeat(Seat seat) async {
    Database db = await DBManager.instance.initDB();
    var id = await db.insert(
      'seat',
      seat.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<List<Seat>> getThisRoomSeats(int homeRoomID) async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query("seat",
        where: "homeroom_id = ?", whereArgs: [homeRoomID], limit: 64);
    List<Seat> list =
        res.isNotEmpty ? res.map((c) => Seat.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> updateseat(Seat seat) async {
    Database db = await DBManager.instance.initDB();
    await db.update(
      'seat',
      seat.toMapNew(),
      where: "id = ?",
      whereArgs: [seat.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
