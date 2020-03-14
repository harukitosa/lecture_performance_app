import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:lecture_performance_app/repositories/Seat.dart';
import 'package:lecture_performance_app/services/HomeRoom.dart';
import 'package:lecture_performance_app/services/Seat.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

void testSeatService() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
  Database db = await initDB();
  var homeRoomRepository = new HomeRoomRepository(db: db);
  var seatRepository = new SeatRepository(db: db);
  var homeRoomService =
      new HomeRoomService(homeRoomRepository: homeRoomRepository);
  var seatService = new SeatService(seatRepository: seatRepository);
  test('SERVICE:SEAT', () async {
    var homeRoomID = await homeRoomService.createHomeRoom(3, 4);
    print("homeRoomID"+homeRoomID.toString());
    await seatService.insertSeatData(homeRoomID);
    var result = await seatService.getThisRoomAllSeatData(homeRoomID);
    print(result);
    expect(result.length, 64);
    var seatList = await seatService.getAllSeatData();
    print(seatList.length);
    expect(seatList[0].used, 'true');
    await seatService.updateSeatData(seatList[0].id, seatList[0].homeRoomID,
        'false', seatList[0].createTime);
    var updateList = await seatService.getAllSeatData();
    expect(updateList[0].used, 'false');
    var seats = await seatService.getThisRoomAllSeatData(homeRoomID);
    expect(seats.length, 64);
  });
}
