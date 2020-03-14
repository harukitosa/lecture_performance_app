import 'dart:async';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:sqflite/sqflite.dart';
import '../db/models/HomeRoom.dart';

class HomeRoomRepository {

  HomeRoomRepository();

  Future<int> insertHomeRoom(HomeRoom homeRoom) async {
    var db = await initDB();
    var id = await db.insert(
        'homeroom',
        homeRoom.toMapNew(),
        conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<HomeRoom>> getHomeRooms() async {
    var db = await initDB();
    final List<Map<String, dynamic>> res = await db.query("homeroom");
    List<HomeRoom> list = res.isNotEmpty ? res.map((c) => HomeRoom.fromMap(c)).toList() : [];
    return list;
  } 

  Future<void> deleteHomeRoom(int id) async {
    var db = await initDB();

    await db.delete(
      'homeroom',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateHomeRoom(HomeRoom homeRoom) async {
    var db = await initDB();
    await db.update(
      'homeroom',
      homeRoom.toMapNew(),
      where: "id = ?",
      whereArgs: [homeRoom.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}