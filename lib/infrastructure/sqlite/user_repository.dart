import 'package:lecture_performance_app/repositories/user_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lecture_performance_app/db/models/User.dart';

class UserRepository extends IUserRepository {
  Database db;
  UserRepository(this.db);

  IUserRepository newUserRepository(Database db) {
    return new UserRepository(db);
  }

  Future<int> insertUser(User user) async {
    var id = await db.insert(
      'user',
      user.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<User> getUser(int id) async {
    final List<Map<String, dynamic>> res =
        await db.query("user", where: "id = ?", whereArgs: [id], limit: 1);
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list[0];
  }

  Future<List<User>> getAllUsers() async {
    final List<Map<String, dynamic>> res = await db.query('user');
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteUser(int id) async {
    await db.delete(
      'user',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateUser(User user) async {
    await db.update(
      'user',
      user.toMapNew(),
      where: "id = ?",
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}