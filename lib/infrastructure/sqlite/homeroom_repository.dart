import 'package:lecture_performance_app/repositories/homeroom_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';


class HomeRoomRepository extends IHomeRoomRepository {
  Database db;
  HomeRoomRepository(this.db);

  IHomeRoomRepository newHomeRoomRepository(Database db) {
    return new HomeRoomRepository(db);
  }

  Future<int> insertHomeRoom(HomeRoom homeRoom) async {
    var id = await db.insert(
      'homeroom',
      homeRoom.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<HomeRoom>> getHomeRooms() async {
    final List<Map<String, dynamic>> res = await db.query("homeroom");
    List<HomeRoom> list =
        res.isNotEmpty ? res.map((c) => HomeRoom.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteHomeRoom(int id) async {
    await db.delete(
      'homeroom',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateHomeRoom(HomeRoom homeRoom) async {
    await db.update(
      'homeroom',
      homeRoom.toMapNew(),
      where: "id = ?",
      whereArgs: [homeRoom.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}