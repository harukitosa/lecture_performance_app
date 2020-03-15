import 'package:lecture_performance_app/repositories/HomeRoom.dart';
import '../db/models/HomeRoom.dart';
import '../utility/time.dart';
class HomeRoomService {

  final HomeRoomRepository homeRoomRepository;
  HomeRoomService({
    this.homeRoomRepository
  });

  Future<List<HomeRoom>> getAllHomeRoom() {
    return homeRoomRepository.getHomeRooms();
  }

  Future<int> createHomeRoom(String grade, String lectureClass) {
    var homeRoom = new HomeRoom(grade: grade, lectureClass: lectureClass);
    var id = homeRoomRepository.insertHomeRoom(homeRoom);
    return id;
  }

  Future<void> editHomeRoom(int id, String grade, String lectureClass, String createdTime) {
    var homeRoom = new HomeRoom(
      id: id, 
      grade: grade, 
      lectureClass: lectureClass, 
      createTime: createdTime,
      updateTime: getNowTime(),
    );
    return homeRoomRepository.updateHomeRoom(homeRoom);
  }

  Future<void> deleteHomeRoom(int id) {
    return homeRoomRepository.deleteHomeRoom(id);
  }
}