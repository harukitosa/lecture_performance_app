import 'dart:async';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:sqflite/sqflite.dart';
import '../db/models/Semester.dart';

class SemesterRepository {
  final Database db;

  SemesterRepository({this.db});

  Future<int> insertSemester(Semester semester) async {
    var db = await initDB();
    var id = await db.insert(
      'semester',
      semester.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<Semester> getSemester(int id) async {
    var db = await initDB();

    final List<Map<String, dynamic>> res =
        await db.query("semester", where: "id = ?", whereArgs: [id], limit: 1);
    List<Semester> list =
        res.isNotEmpty ? res.map((c) => Semester.fromMap(c)).toList() : [];
    return list[0];
  }

  Future<List<Semester>> getAllSemesters() async {
    var db = await initDB();

    final List<Map<String, dynamic>> res = await db.query('semester');
    List<Semester> list =
        res.isNotEmpty ? res.map((c) => Semester.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteSemester(int id) async {
    var db = await initDB();

    await db.delete(
      'semester',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateSemester(Semester semester) async {
    var db = await initDB();

    var id = await db.update(
      'semester',
      semester.toMapNew(),
      where: "id = ?",
      whereArgs: [semester.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    return id;
  }
}
