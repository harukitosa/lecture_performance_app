import 'package:lecture_performance_app/repositories/homeroom_repository.dart';
import '../db/models/HomeRoom.dart';
import '../utility/time.dart';

class HomeRoomService {
  HomeRoomService(this.homeRoomRepository);

  final IHomeRoomRepository homeRoomRepository;

  Future<List<HomeRoom>> getAllHomeRoom() {
    return homeRoomRepository.getHomeRooms();
  }

  Future<int> createHomeRoom(String grade, String lectureClass) {
    final homeRoom = HomeRoom(grade: grade, lectureClass: lectureClass);
    final id = homeRoomRepository.insertHomeRoom(homeRoom);
    return id;
  }

  Future<void> editHomeRoom(
      int id, String grade, String lectureClass, String createdTime) {
    final homeRoom = HomeRoom(
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
