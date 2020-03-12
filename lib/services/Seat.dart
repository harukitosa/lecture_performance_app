import 'package:lecture_performance_app/repositories/Seat.dart';
import 'package:lecture_performance_app/utility/time.dart';
import '../db/models/Seat.dart';
class SeatService {

  final SeatRepository seatRepository;
  SeatService({
    this.seatRepository
  });

  Future<List<Seat>> getAllSeatData() async {
    return seatRepository.getAllseats();
  }

  Future<void> updateSeatData(int id, String used, String createTime) async {
    var seat = new Seat(
      id: id, 
      used: used, 
      createTime: createTime,
      updateTime: getNowTime(),
    );
    seatRepository.updateseat(seat);
  }
}