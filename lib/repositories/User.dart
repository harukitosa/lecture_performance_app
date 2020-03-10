import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../db/models/User.dart';

class UserRepository {
  final Database db;

  UserRepository({
    this.db
  });

  Future<void> insertUser(User user) async {
    await db.insert(
        'user',
        user.toMapNew(),
        conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getAllUsers() async {
    final List<Map<String, dynamic>> res = await db.query('user');
    List<User> list = res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
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