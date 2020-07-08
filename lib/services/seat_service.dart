import 'package:lecture_performance_app/repositories/seat_repository.dart';
import 'package:lecture_performance_app/utility/time.dart';
import 'package:lecture_performance_app/db/models/Seat.dart';

class SeatService {
  SeatService(this.seatRepository);
  final ISeatRepository seatRepository;

  Future<List<Seat>> getAllSeatData() async {
    return seatRepository.getAllseats();
  }

  Future<List<Seat>> getThisRoomAllSeatData(int homeRoomID) async {
    return seatRepository.getThisRoomSeats(homeRoomID);
  }

  Future<void> insertSeatData(int homeRoomID, String flag) async {
    final seat = Seat(homeRoomID: homeRoomID, used: flag);
    await seatRepository.insertSeat(seat);
  }

  Future<void> updateSeatData(
      int id, int homeRoomID, String used, String createTime) async {
    final seat = Seat(
      id: id,
      homeRoomID: homeRoomID,
      used: used,
      createTime: createTime,
      updateTime: getNowTime(),
    );
    await seatRepository.updateseat(seat);
  }
}
