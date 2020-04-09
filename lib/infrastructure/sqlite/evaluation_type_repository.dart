import 'package:lecture_performance_app/repositories/evaluation_type_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lecture_performance_app/db/models/EvaluationType.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

IEvaluationTypeRepository newEvaluationTypeRepository() {
  return new EvaluationTypeRepository();
}

class EvaluationTypeRepository extends IEvaluationTypeRepository {
  EvaluationTypeRepository();

  Future<int> insertEvaluationType(EvaluationType evaluationType) async {
    Database db = await DBManager.instance.initDB();
    var id = await db.insert(
      'evaluation_type',
      evaluationType.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<EvaluationType> getEvaluationType(int id) async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query("evaluation_type",
        where: "id = ?", whereArgs: [id], limit: 1);
    List<EvaluationType> list = res.isNotEmpty
        ? res.map((c) => EvaluationType.fromMap(c)).toList()
        : [];
    return list[0];
  }

  Future<List<EvaluationType>> getAllEvaluationTypes() async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query('evaluation_type');
    List<EvaluationType> list = res.isNotEmpty
        ? res.map((c) => EvaluationType.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<void> deleteEvaluationType(int id) async {
    Database db = await DBManager.instance.initDB();
    await db.delete(
      'evaluation_type',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateEvaluationType(EvaluationType evaluationType) async {
    Database db = await DBManager.instance.initDB();
    await db.update(
      'evaluation_type',
      evaluationType.toMapNew(),
      where: "id = ?",
      whereArgs: [evaluationType.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
