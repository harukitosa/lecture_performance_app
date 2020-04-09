import 'package:lecture_performance_app/repositories/homeroom_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

IHomeRoomRepository newHomeRoomRepository() {
  return new HomeRoomRepository();
}

class HomeRoomRepository extends IHomeRoomRepository {
  HomeRoomRepository();

  Future<int> insertHomeRoom(HomeRoom homeRoom) async {
    Database db = await DBManager.instance.initDB();
    var id = await db.insert(
      'homeroom',
      homeRoom.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<HomeRoom>> getHomeRooms() async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query("homeroom");
    List<HomeRoom> list =
        res.isNotEmpty ? res.map((c) => HomeRoom.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteHomeRoom(int id) async {
    Database db = await DBManager.instance.initDB();
    await db.delete(
      'homeroom',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateHomeRoom(HomeRoom homeRoom) async {
    Database db = await DBManager.instance.initDB();
    await db.update(
      'homeroom',
      homeRoom.toMapNew(),
      where: "id = ?",
      whereArgs: [homeRoom.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
