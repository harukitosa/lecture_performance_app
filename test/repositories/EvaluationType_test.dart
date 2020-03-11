import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lecture_performance_app/repositories/EvaluationType.dart';
import 'package:lecture_performance_app/db/models/EvaluationType.dart';

void testEvaluationTypeRepository() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
    Database db = await initDB();
    var evaluationTypeRepository = new EvaluationTypeRepository(db: db);
    test('REPOSITORY:INSERT EVALUATIONTYPE', () async {
        var evaluationType = new EvaluationType(title: "いいね");
        var id = await evaluationTypeRepository.insertEvaluationType(evaluationType);
        var response = await evaluationTypeRepository.getEvaluationType(id);
        expect(response.title, 'いいね');
        expect(response.id, id);
        evaluationTypeRepository.deleteEvaluationType(id);
    });

    test('REPOSITORY:DELETE EVALUATIONTYPE', () async {
        var evaluationType = new EvaluationType(title: "いいね");
        var id = await evaluationTypeRepository.insertEvaluationType(evaluationType);
        var response = await evaluationTypeRepository.getEvaluationType(id);
        expect(response.title, 'いいね');
        expect(response.id, id);
        evaluationTypeRepository.deleteEvaluationType(id);
        var allRes = await evaluationTypeRepository.getAllEvaluationTypes();
        expect(allRes.length, 0);
    });

    test('REPOSITORY:UPDATE EVALUATIONTYPE', () async {
        var evaluationType = new EvaluationType(title: "いいね");
        var id = await evaluationTypeRepository.insertEvaluationType(evaluationType);
        var response = await evaluationTypeRepository.getEvaluationType(id);
        expect(response.title, 'いいね');
        expect(response.id, id);
        var update = new EvaluationType(id: response.id, title: "発音", createTime: response.createTime, updateTime: response.updateTime);
        await evaluationTypeRepository.updateEvaluationType(update);
        var res = await evaluationTypeRepository.getEvaluationType(response.id);
        expect(res.title, '発音');
    });
}