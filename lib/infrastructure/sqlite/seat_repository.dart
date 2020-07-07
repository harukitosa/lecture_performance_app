import 'package:lecture_performance_app/db/models/Seat.dart';
import 'package:lecture_performance_app/repositories/seat_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

ISeatRepository newSeatRepository() {
  return SeatRepository();
}

class SeatRepository extends ISeatRepository {
  SeatRepository();

  @override
  Future<Seat> getseat(int id) async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    final args = [id];
    res = await db.query('seat', where: 'id = ?', whereArgs: args, limit: 1);
    List<Seat> list;
    list = res.isNotEmpty ? res.map((c) => Seat.fromMap(c)).toList() : [];
    return list[0];
  }

  @override
  Future<List<Seat>> getAllseats() async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    res = await db.query('seat');
    return res.isNotEmpty ? res.map((c) => Seat.fromMap(c)).toList() : [];
  }

  @override
  Future<int> insertSeat(Seat seat) async {
    Database db;
    db = await DBManager.instance.initDB();
    final id = await db.insert(
      'seat',
      seat.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  @override
  Future<List<Seat>> getThisRoomSeats(int homeRoomID) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [homeRoomID];
    List<Map<String, dynamic>> res;
    res = await db.query('seat',
        where: 'homeroom_id = ?', whereArgs: args, limit: 64);
    return res.isNotEmpty ? res.map((c) => Seat.fromMap(c)).toList() : [];
  }

  @override
  Future<void> updateseat(Seat seat) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [seat.id];
    await db.update(
      'seat',
      seat.toMapNew(),
      where: 'id = ?',
      whereArgs: args,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
