import 'package:lecture_performance_app/repositories/evaluation_type_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lecture_performance_app/db/models/EvaluationType.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

IEvaluationTypeRepository newEvaluationTypeRepository() {
  return EvaluationTypeRepository();
}

class EvaluationTypeRepository extends IEvaluationTypeRepository {
  EvaluationTypeRepository();

  @override
  Future<int> insertEvaluationType(EvaluationType evaluationType) async {
    Database db;
    db = await DBManager.instance.initDB();
    final id = await db.insert(
      'evaluation_type',
      evaluationType.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  @override
  Future<EvaluationType> getEvaluationType(int id) async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    final args = [id];
    res = await db.query('evaluation_type',
        where: 'id = ?', whereArgs: args, limit: 1);
    List<EvaluationType> list;
    list = res.isNotEmpty
        ? res.map((c) => EvaluationType.fromMap(c)).toList()
        : [];
    return list[0];
  }

  @override
  Future<List<EvaluationType>> getAllEvaluationTypes() async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    res = await db.query('evaluation_type');
    return res.isNotEmpty
        ? res.map((c) => EvaluationType.fromMap(c)).toList()
        : [];
  }

  @override
  Future<void> deleteEvaluationType(int id) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [id];
    await db.delete(
      'evaluation_type',
      where: 'id = ?',
      whereArgs: args,
    );
  }

  @override
  Future<void> updateEvaluationType(EvaluationType evaluationType) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [evaluationType.id];
    await db.update(
      'evaluation_type',
      evaluationType.toMapNew(),
      where: 'id = ?',
      whereArgs: args,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
