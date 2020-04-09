import 'package:lecture_performance_app/repositories/evaluation_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lecture_performance_app/db/models/Evaluation.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

IEvaluationRepository newEvaluationRepository() {
  return EvaluationRepository();
}

class EvaluationRepository extends IEvaluationRepository {
  EvaluationRepository();

  Future<int> insertEvaluation(Evaluation evaluation) async {
    Database db = await DBManager.instance.initDB();
    var id = await db.insert(
      'evaluation',
      evaluation.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<Evaluation> getEvaluation(int id) async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query(
      "evaluation",
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );
    List<Evaluation> list =
        res.isNotEmpty ? res.map((c) => Evaluation.fromMap(c)).toList() : [];
    return list[0];
  }

  Future<List<Evaluation>> getStudentSemester(int studentID) async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query(
      "evaluation",
      where: "student_id = ?",
      whereArgs: [studentID],
      orderBy: "created_at DESC",
    );
    List<Evaluation> list =
        res.isNotEmpty ? res.map((c) => Evaluation.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Evaluation>> getEvaluationByType(
    int typeID,
    int studentID,
  ) async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query(
      "evaluation",
      where: "type_id = ? AND student_id = ?",
      whereArgs: [typeID, studentID],
    );
    List<Evaluation> list =
        res.isNotEmpty ? res.map((c) => Evaluation.fromMap(c)).toList() : [];
    return list;
  }

  // 最新10件の成績を返す
  Future<List<Evaluation>> getLatestStudent(int studentID) async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query(
      "evaluation",
      where: "student_id = ?",
      whereArgs: [studentID],
      orderBy: "created_at DESC",
      limit: 10,
    );
    List<Evaluation> list =
        res.isNotEmpty ? res.map((c) => Evaluation.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Evaluation>> getAllEvaluations() async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query('evaluation');
    List<Evaluation> list =
        res.isNotEmpty ? res.map((c) => Evaluation.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteEvaluation(int id) async {
    Database db = await DBManager.instance.initDB();
    await db.delete(
      'evaluation',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateEvaluation(Evaluation evaluation) async {
    Database db = await DBManager.instance.initDB();
    await db.update(
      'evaluation',
      evaluation.toMapNew(),
      where: "id = ?",
      whereArgs: [evaluation.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
