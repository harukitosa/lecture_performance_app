import 'dart:async';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:sqflite/sqflite.dart';
import '../db/models/EvaluationType.dart';

class EvaluationTypeRepository {
  EvaluationTypeRepository();

  Future<int> insertEvaluationType(EvaluationType evaluationType) async {
    var db = await initDB();
    var id = await db.insert(
      'evaluation_type',
      evaluationType.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<EvaluationType> getEvaluationType(int id) async {
    var db = await initDB();
    final List<Map<String, dynamic>> res = await db.query("evaluation_type",
        where: "id = ?", whereArgs: [id], limit: 1);
    List<EvaluationType> list = res.isNotEmpty
        ? res.map((c) => EvaluationType.fromMap(c)).toList()
        : [];
    return list[0];
  }

  Future<List<EvaluationType>> getAllEvaluationTypes() async {
    var db = await initDB();
    final List<Map<String, dynamic>> res = await db.query('evaluation_type');
    List<EvaluationType> list = res.isNotEmpty
        ? res.map((c) => EvaluationType.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<void> deleteEvaluationType(int id) async {
    var db = await initDB();
    await db.delete(
      'evaluation_type',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateEvaluationType(EvaluationType evaluationType) async {
    var db = await initDB();
    await db.update(
      'evaluation_type',
      evaluationType.toMapNew(),
      where: "id = ?",
      whereArgs: [evaluationType.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
