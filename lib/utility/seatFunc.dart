import 'package:lecture_performance_app/config/DataConfig.dart';
import 'package:lecture_performance_app/db/models/seat.dart';

class FormatResultSeat {
  List<Seat> seat;
  int width;
  FormatResultSeat(
    this.seat,
    this.width,
  );
}

// 列、行、共に空白の欄を取り除いて出力
FormatResultSeat calcSeatLen(List<Seat> dataSeat) {
  final width = AppDataConfig().seatWidth;
  var resWidth = width;
  final widthEmpty = <int>[];
  final resSeat = <Seat>[];
  final ansSeat = <Seat>[];
  for (var i = 0; i < width; i++) {
    var flag = false;
    for (var j = 0; j < dataSeat.length / width; j++) {
      if (dataSeat[i + j * width].used == 'true') {
        flag = true;
      }
    }
    if (!flag) {
      resWidth--;
      widthEmpty.add(i);
    }
  }

  for (var i = 0; i < dataSeat.length; i++) {
    var flag = false;
    for (var j = 0; j < widthEmpty.length; j++) {
      if ((i - widthEmpty[j]) % width == 0) {
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

  for (var i = 0; i < resSeat.length / resWidth; i++) {
    var flag = false;
    for (var j = i * resWidth; j < i * resWidth + resWidth; j++) {
      if (resSeat[j].used == 'true') {
        flag = true;
      }
    }
    if (flag) {
      for (var j = i * resWidth; j < i * resWidth + resWidth; j++) {
        ansSeat.add(
          Seat(
            id: resSeat[j].id,
            used: resSeat[j].used,
            createTime: resSeat[j].createTime,
            updateTime: resSeat[j].updateTime,
            homeRoomID: resSeat[j].homeRoomID,
          ),
        );
      }
    }
  }

  return FormatResultSeat(ansSeat, resWidth);
}
