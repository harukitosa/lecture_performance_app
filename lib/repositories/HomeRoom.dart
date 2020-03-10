import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../db/models/HomeRoom.dart';

class HomeRoomRepository {
  final Database db;

  HomeRoomRepository({
    this.db
  });

  Future<void> insertHomeRoom(HomeRoom homeRoom) async {
    await db.insert(
        'homeroom',
        homeRoom.toMapNew(),
        conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<HomeRoom>> getHomeRoom(int id) async {
    final List<Map<String, dynamic>> res = await db.query("homeroom", where: "id = ?", whereArgs: [id], limit: 1);
    List<HomeRoom> list = res.isNotEmpty ? res.map((c) => HomeRoom.fromMap(c)).toList() : [];
    return list;
  } 

  Future<List<HomeRoom>> getAllHomeRooms() async {
    final List<Map<String, dynamic>> res = await db.query('homeroom');
    List<HomeRoom> list = res.isNotEmpty ? res.map((c) => HomeRoom.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteHomeRooms(int id) async {
    await db.delete(
      'homeroom',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateHomeRooms(HomeRoom homeRoom) async {
    await db.update(
      'homeroom',
      homeRoom.toMapNew(),
      where: "id = ?",
      whereArgs: [homeRoom.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}