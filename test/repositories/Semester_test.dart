import 'package:lecture_performance_app/db/models/Semester.dart';
import 'package:lecture_performance_app/repositories/Semester.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture_performance_app/db/models/HomeRoom.dart';
import 'package:lecture_performance_app/repositories/HomeRoom.dart';

void testSemesterRepository() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
    var homeRoomRepository = new HomeRoomRepository();
    var semesterRepository = new SemesterRepository();

    test('REPOSITORY:INSERT SEMESTER', () async {
        var homeRoom = new HomeRoom(grade: "1", lectureClass: "2");
        homeRoomRepository.insertHomeRoom(homeRoom);
        var homeRooms = await homeRoomRepository.getHomeRooms();
        var semester = new Semester(homeRoomID: homeRooms[0].id, title: "春学期");
        var id = await semesterRepository.insertSemester(semester);
        expect(id, 1);
        var resSemester = await semesterRepository.getSemester(id);
        expect(resSemester.title, "春学期");
        expect(resSemester.homeRoomID, homeRooms[0].id);
    });

    test("REPOSITORY:DELETE SEMESTER", () async {
        var homeRoom = new HomeRoom(grade: "1", lectureClass: "2");
        homeRoomRepository.insertHomeRoom(homeRoom);
        var homeRooms = await homeRoomRepository.getHomeRooms();
        var semester = new Semester(homeRoomID: homeRooms[0].id, title: "春学期");
        await semesterRepository.insertSemester(semester);
        var semesters = await semesterRepository.getAllSemesters();
        for(int i = 0;i < semesters.length;i++) {
           semesterRepository.deleteSemester(semesters[i].id);
        }
        var allSemester= await semesterRepository.getAllSemesters();

        expect(allSemester.length, 0);
    });

    test('REPOSITORY:UPDATE SEMESTER', () async {
        var homeRoom = new HomeRoom(grade: "1", lectureClass: "2");
        homeRoomRepository.insertHomeRoom(homeRoom);
        var homeRooms = await homeRoomRepository.getHomeRooms();
        var semester = new Semester(homeRoomID: homeRooms[0].id, title: "春学期");
        var id = await semesterRepository.insertSemester(semester);
        var resSemester = await semesterRepository.getSemester(id);
        var updateSemester = new Semester(id: resSemester.id, title: "秋学期", createTime: resSemester.createTime, updateTime: resSemester.updateTime, homeRoomID: resSemester.homeRoomID);
        await semesterRepository.updateSemester(updateSemester);
        var beforeSemester = await semesterRepository.getSemester(id);
        expect(beforeSemester.title, "秋学期");
    });
}