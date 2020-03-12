import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:lecture_performance_app/db/models/Seat.dart';
import 'package:lecture_performance_app/repositories/Seat.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


void testSeatRepository() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
  Database db = await initDB();
  var seatRepository = new SeatRepository(db: db);

  test("REPOSITORY:UPDATE SEAT", () async {
      var seats = await seatRepository.getAllseats();
      var seat = new Seat(id: seats[0].id, used: "false", updateTime: seats[0].updateTime, createTime: seats[0].createTime);
      seatRepository.updateseat(seat);
      var res = await seatRepository.getAllseats();
      expect(res[0].used, "false");
  });

  return;
}

