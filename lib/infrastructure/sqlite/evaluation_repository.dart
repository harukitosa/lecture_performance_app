import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:lecture_performance_app/db/models/evaluation.dart';
import 'package:lecture_performance_app/repositories/evaluation_repository.dart';
import 'package:sqflite/sqflite.dart';

IEvaluationRepository newEvaluationRepository() {
  return EvaluationRepository();
}

class EvaluationRepository extends IEvaluationRepository {
  EvaluationRepository();

  @override
  Future<int> insertEvaluation(Evaluation evaluation) async {
    Database db;
    db = await DBManager.instance.initDB();
    final id = await db.insert(
      'evaluation',
      evaluation.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  @override
  Future<Evaluation> getEvaluation(int id) async {
    Database db;
    db = await DBManager.instance.initDB();

    List<Map<String, dynamic>> res;
    final args = [id];
    res = await db.query(
      'evaluation',
      where: 'id = ?',
      whereArgs: args,
      limit: 1,
    );
    List<Evaluation> list;
    list = res.isNotEmpty ? res.map((c) => Evaluation.fromMap(c)).toList() : [];
    return list[0];
  }

  @override
  Future<List<Evaluation>> getStudentSemester(int studentID) async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    final args = [studentID];
    res = await db.query(
      'evaluation',
      where: 'student_id = ?',
      whereArgs: args,
      orderBy: 'created_at DESC',
    );
    return res.isNotEmpty ? res.map((c) => Evaluation.fromMap(c)).toList() : [];
  }

  @override
  Future<List<Evaluation>> getEvaluationByType(
    int typeID,
    int studentID,
  ) async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    final args = [typeID, studentID];
    res = await db.query(
      'evaluation',
      where: 'type_id = ? AND student_id = ?',
      whereArgs: args,
    );
    return res.isNotEmpty ? res.map((c) => Evaluation.fromMap(c)).toList() : [];
  }

  // 最新10件の成績を返す
  @override
  Future<List<Evaluation>> getLatestStudent(int studentID) async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    final args = [studentID];
    res = await db.query(
      'evaluation',
      where: 'student_id = ?',
      whereArgs: args,
      orderBy: 'created_at DESC',
      limit: 10,
    );

    return res.isNotEmpty ? res.map((c) => Evaluation.fromMap(c)).toList() : [];
  }

  @override
  Future<List<Evaluation>> getAllEvaluations() async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    res = await db.query('evaluation');
    return res.isNotEmpty ? res.map((c) => Evaluation.fromMap(c)).toList() : [];
  }

  @override
  Future<void> deleteEvaluation(int id) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [id];
    await db.delete(
      'evaluation',
      where: 'id = ?',
      whereArgs: args,
    );
  }

  @override
  Future<void> updateEvaluation(Evaluation evaluation) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [evaluation.id];
    await db.update(
      'evaluation',
      evaluation.toMapNew(),
      where: 'id = ?',
      whereArgs: args,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
