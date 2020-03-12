
import 'package:lecture_performance_app/repositories/Seat.dart';
import 'package:lecture_performance_app/services/Seat.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

  void testSeatService() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
    Database db = await initDB();
    var seatRepository = new SeatRepository(db: db);
    var seatService = new SeatService(seatRepository: seatRepository);
    test('SERVICE:SEAT',() async {
      var seatList = await seatService.getAllSeatData();
      expect(seatList[0].used, 'true');
      await seatService.updateSeatData(seatList[0].id, 'false', seatList[0].createTime);
      var updateList = await seatService.getAllSeatData();
      expect(updateList[0].used, 'false');
  });
}