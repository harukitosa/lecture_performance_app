
import 'package:lecture_performance_app/repositories/EvaluationType.dart';
import 'package:lecture_performance_app/services/EvaluationType.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

void testEvaluationTypeService() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
  Database db = await initDB();
  var evaluationTypeRepository = new EvaluationTypeRepository(db: db);
  var evaluationTypeService = new EvaluationTypeService(evaluationTypeRepository: evaluationTypeRepository);
  test('SERVICE:EvaluationType',() async {
    await evaluationTypeService.createEvaluationType('発音');
    var evaluationTypeList = await evaluationTypeService.getAllEvaluationType();
    expect(evaluationTypeList[0].title, '発音');
    evaluationTypeService.editEvaluationType(evaluationTypeList[0].id, '積極性', evaluationTypeList[0].createTime);
    var updateList = await evaluationTypeService.getAllEvaluationType();
    expect(updateList[0].title, '積極性');
    await evaluationTypeService.deleteEvaluationType(evaluationTypeList[0].id);
    var deleteList = await evaluationTypeService.getAllEvaluationType();
    expect(deleteList.length, 0);
  });
}