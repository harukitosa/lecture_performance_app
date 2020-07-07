import 'package:lecture_performance_app/repositories/semester_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lecture_performance_app/db/models/Semester.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

ISemesterRepository newSemesterRepository() {
  return SemesterRepository();
}

class SemesterRepository extends ISemesterRepository {
  SemesterRepository();

  @override
  Future<int> insertSemester(Semester semester) async {
    Database db;
    db = await DBManager.instance.initDB();
    final id = await db.insert(
      'semester',
      semester.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  @override
  Future<Semester> getSemester(int id) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [id];
    List<Map<String, dynamic>> res;
    res =
        await db.query('semester', where: 'id = ?', whereArgs: args, limit: 1);
    List<Semester> list;
    list = res.isNotEmpty ? res.map((c) => Semester.fromMap(c)).toList() : [];
    return list[0];
  }

  @override
  Future<List<Semester>> getAllSemesters() async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    res = await db.query('semester');
    return res.isNotEmpty ? res.map((c) => Semester.fromMap(c)).toList() : [];
  }

  @override
  Future<void> deleteSemester(int id) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [id];
    await db.delete(
      'semester',
      where: 'id = ?',
      whereArgs: args,
    );
  }

  @override
  Future<int> updateSemester(Semester semester) async {
    Database db;
    var args = [semester.id];
    db = await DBManager.instance.initDB();
    final id = await db.update(
      'semester',
      semester.toMapNew(),
      where: 'id = ?',
      whereArgs: args,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    return id;
  }
}
