import 'package:lecture_performance_app/repositories/semester_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lecture_performance_app/db/models/Semester.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

ISemesterRepository newSemesterRepository() {
  return new SemesterRepository();
}

class SemesterRepository extends ISemesterRepository {
  SemesterRepository();

  Future<int> insertSemester(Semester semester) async {
        Database db = await DBManager.instance.initDB();
    var id = await db.insert(
      'semester',
      semester.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<Semester> getSemester(int id) async {
        Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res =
        await db.query("semester", where: "id = ?", whereArgs: [id], limit: 1);
    List<Semester> list =
        res.isNotEmpty ? res.map((c) => Semester.fromMap(c)).toList() : [];
    return list[0];
  }

  Future<List<Semester>> getAllSemesters() async {
        Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query('semester');
    List<Semester> list =
        res.isNotEmpty ? res.map((c) => Semester.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteSemester(int id) async {
        Database db = await DBManager.instance.initDB();
    await db.delete(
      'semester',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateSemester(Semester semester) async {
        Database db = await DBManager.instance.initDB();
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
