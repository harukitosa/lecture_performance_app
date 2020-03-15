import 'package:lecture_performance_app/db/models/Seat.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';

class FormatResultSeat {
  List<Seat> seat;
  int width;
  FormatResultSeat(
    this.seat,
    this.width,
  );
}

FormatResultSeat calcSeatLen(List<Seat> dataSeat) {
  int width = new AppDataConfig().seatWidth;
  int resWidth = width;
  List<int> widthEmpty = [];
  List<Seat> resSeat = [];
  for (var i = 0; i < width; i++) {
    bool flag = false;
    for (var j = 0; j < dataSeat.length / width; j++) {
      if (dataSeat[i + j * width].used == "true") {
        flag = true;
      }
    }
    if (!flag) {
      resWidth--;
      widthEmpty.add(i);
    }
  }

  for (var i = 0; i < dataSeat.length; i++) {
    bool flag = false;
    for (var j = 0; j < widthEmpty.length; j++) {
      if ((i - widthEmpty[j]) % 7 == 0) {
        flag = true;
      }
    }
    if (!flag) {
      resSeat.add(
        Seat(
          id: dataSeat[i].id,
          used: dataSeat[i].used,
          createTime: dataSeat[i].createTime,
          homeRoomID: dataSeat[i].homeRoomID,
          updateTime: dataSeat[i].updateTime,
        ),
      );
    }
  }

  return FormatResultSeat(resSeat, resWidth);
}
