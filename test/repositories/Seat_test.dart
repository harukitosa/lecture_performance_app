import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:lecture_performance_app/db/models/Seat.dart';
import 'package:lecture_performance_app/repositories/Seat.dart';
// import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void testSeatRepository() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
  Database db = await initDB();
  var seatRepository = new SeatRepository(db: db);
  var homeRoomRepository = new HomeRoomRepository(db: db);

  test("REPOSITORY:INSERT SEAT", () async {
    var homeRoom = new HomeRoom(grade: 1, lectureClass: 2);
    var id = await homeRoomRepository.insertHomeRoom(homeRoom);
    var seat = new Seat(
      used: "false",
      homeRoomID: id,
    );
    seatRepository.insertSeat(seat);
    var seats = await seatRepository.getThisRoomSeats(id);
    expect(seats.length, 1);
    expect(seats[0].used, 'false');
    expect(seats[0].homeRoomID, id);
    print(id);
    var all = await seatRepository.getThisRoomSeats(1);
    print("length:" + all.length.toString());
  });
  test("REPOSITORY:UPDATE SEAT", () async {
    var seats = await seatRepository.getAllseats();
    var seat = new Seat(
      id: seats[0].homeRoomID,
      used: "false",
      updateTime: seats[0].updateTime,
      createTime: seats[0].createTime,
    );
    seatRepository.updateseat(seat);
    var res = await seatRepository.getAllseats();
    expect(res[0].used, "false");
  });

  return;
}
