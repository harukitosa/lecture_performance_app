import 'package:lecture_performance_app/repositories/user_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lecture_performance_app/db/models/User.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

IUserRepository newUserRepository() {
  return UserRepository();
}

class UserRepository extends IUserRepository {
  UserRepository();

  @override
  Future<int> insertUser(User user) async {
    Database db;
    db = await DBManager.instance.initDB();
    final id = await db.insert(
      'user',
      user.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  @override
  Future<User> getUser(int id) async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    final args = [id];
    res = await db.query('user', where: 'id = ?', whereArgs: args, limit: 1);
    List<User> list;
    list = res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list[0];
  }

  @override
  Future<List<User>> getAllUsers() async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    res = await db.query('user');
    return res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
  }

  @override
  Future<void> deleteUser(int id) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [id];
    await db.delete(
      'user',
      where: 'id = ?',
      whereArgs: args,
    );
  }

  @override
  Future<void> updateUser(User user) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [user.id];
    await db.update(
      'user',
      user.toMapNew(),
      where: 'id = ?',
      whereArgs: args,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
