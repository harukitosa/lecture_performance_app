import 'dart:async';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:sqflite/sqflite.dart';
import '../db/models/Evaluation.dart';

class EvaluationRepository {
  EvaluationRepository();

  Future<int> insertEvaluation(Evaluation evaluation) async {
    var db = await initDB();
    var id = await db.insert(
      'evaluation',
      evaluation.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<Evaluation> getEvaluation(int id) async {
    var db = await initDB();

    final List<Map<String, dynamic>> res = await db.query("evaluation",
        where: "id = ?", whereArgs: [id], limit: 1);
    List<Evaluation> list =
        res.isNotEmpty ? res.map((c) => Evaluation.fromMap(c)).toList() : [];
    return list[0];
  }

  Future<List<Evaluation>> getStudentSemester(
      int studentID, int semesterID) async {
    var db = await initDB();
    final List<Map<String, dynamic>> res = await db.query(
      "evaluation",
      where: "student_id = ? AND semester_id = ?",
      whereArgs: [studentID, semesterID],
    );
    List<Evaluation> list =
        res.isNotEmpty ? res.map((c) => Evaluation.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Evaluation>> getAllEvaluations() async {
    var db = await initDB();
    final List<Map<String, dynamic>> res = await db.query('evaluation');
    List<Evaluation> list =
        res.isNotEmpty ? res.map((c) => Evaluation.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteEvaluation(int id) async {
    var db = await initDB();
    await db.delete(
      'evaluation',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateEvaluation(Evaluation evaluation) async {
    var db = await initDB();
    await db.update(
      'evaluation',
      evaluation.toMapNew(),
      where: "id = ?",
      whereArgs: [evaluation.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
