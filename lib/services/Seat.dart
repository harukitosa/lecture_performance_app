import 'package:lecture_performance_app/repositories/Seat.dart';
import 'package:lecture_performance_app/utility/time.dart';
import 'package:lecture_performance_app/db/models/Seat.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';
class SeatService {

  final SeatRepository seatRepository;
  SeatService({
    this.seatRepository
  });

  Future<List<Seat>> getAllSeatData() async {
    return seatRepository.getAllseats();
  }

  Future<List<Seat>> getThisRoomAllSeatData(int homeRoomID) async {
    return seatRepository.getThisRoomSeats(homeRoomID);
  }

  Future<void> insertSeatData(int homeRoomID) async {
    var dataConfig = new AppDataConfig();
    var seat = new Seat(
      homeRoomID: homeRoomID,
      used: "true"
    );
    for(var i = 0;i < dataConfig.seatNum;i++) {
      await seatRepository.insertSeat(seat);
    }
  }

  Future<void> updateSeatData(int id, int homeRoomID, String used, String createTime) async {
    var seat = new Seat(
      id: id, 
      homeRoomID: homeRoomID,
      used: used, 
      createTime: createTime,
      updateTime: getNowTime(),
    );
    seatRepository.updateseat(seat);
  }
}