import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:lecture_performance_app/db/models/homeroom.dart';
import 'package:lecture_performance_app/repositories/homeroom_repository.dart';
import 'package:sqflite/sqflite.dart';

IHomeRoomRepository newHomeRoomRepository() {
  return HomeRoomRepository();
}

class HomeRoomRepository extends IHomeRoomRepository {
  HomeRoomRepository();

  @override
  Future<int> insertHomeRoom(HomeRoom homeRoom) async {
    Database db;
    db = await DBManager.instance.initDB();
    final id = await db.insert(
      'homeroom',
      homeRoom.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  @override
  Future<List<HomeRoom>> getHomeRooms() async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    res = await db.query('homeroom');
    return res.isNotEmpty ? res.map((c) => HomeRoom.fromMap(c)).toList() : [];
  }

  @override
  Future<void> deleteHomeRoom(int id) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [id];
    await db.delete(
      'homeroom',
      where: 'id = ?',
      whereArgs: args,
    );
  }

  @override
  Future<void> updateHomeRoom(HomeRoom homeRoom) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [homeRoom.id];
    await db.update(
      'homeroom',
      homeRoom.toMapNew(),
      where: 'id = ?',
      whereArgs: args,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
