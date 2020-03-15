import 'dart:async';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:sqflite/sqflite.dart';
import '../db/models/User.dart';

class UserRepository {

  UserRepository();

  Future<int> insertUser(User user) async {
    var db = await initDB();
    var id = await db.insert(
        'user',
        user.toMapNew(),
        conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<User> getUser(int id) async {
    var db = await initDB();
    final List<Map<String, dynamic>> res = await db.query("user", where: "id = ?", whereArgs: [id], limit: 1);
    List<User> list = res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list[0];
  } 

  Future<List<User>> getAllUsers() async {
    var db = await initDB();
    final List<Map<String, dynamic>> res = await db.query('user');
    List<User> list = res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteUser(int id) async {
    var db = await initDB();
    await db.delete(
      'user',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateUser(User user) async {
    var db = await initDB();
    await db.update(
      'user',
      user.toMapNew(),
      where: "id = ?",
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}