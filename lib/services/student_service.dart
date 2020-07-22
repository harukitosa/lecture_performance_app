import 'package:lecture_performance_app/db/models/student.dart';
import 'package:lecture_performance_app/repositories/student_repository.dart';

import '../utility/time.dart';

class StudentService {
  StudentService(this.studentRepository);
  final IStudentRepository studentRepository;

  Future<List<Student>> getRoomStudents(int homeroomID) async {
    return studentRepository.getThisRoomStudent(homeroomID);
  }

  Future<Student> getStudent(int id) async {
    return studentRepository.getOneStudent(id);
  }

  Future<List<Student>> getAllStudent() async {
    return studentRepository.getAllStudents();
  }

  Future<int> createStudent(
    int homeRoomID,
    String firstName,
    String lastName,
    int number,
  ) async {
    final students = await studentRepository.getThisRoomStudent(homeRoomID);
    var maxPosition = 0;

    for (var i = 0; i < students.length; i++) {
      if (maxPosition < students[i].positionNum) {
        maxPosition = students[i].positionNum;
      }
    }
    final student = Student(
      homeRoomID: homeRoomID,
      firstName: firstName,
      lastName: lastName,
      positionNum: maxPosition + 1,
      number: number,
    );
    final id = studentRepository.insertStudent(student);
    return id;
  }

  Future<void> editstudent(
    int id,
    int homeRoomID,
    int positionNum,
    String firstName,
    String lastName,
    int number,
    String createTime,
  ) {
    final student = Student(
      id: id,
      homeRoomID: homeRoomID,
      positionNum: positionNum,
      number: number,
      firstName: firstName,
      lastName: lastName,
      createTime: createTime,
      updateTime: getNowTime(),
    );
    return studentRepository.updateStudent(student);
  }

  Future<void> deleteStudent(int id) {
    return studentRepository.deleteStudent(id);
  }

  /// 席替えを行う
  /// @params
  /// int firstID, secondID
  Future<void> changePositionNum(int firstID, int secondID) async {
    final first = await studentRepository.getOneStudent(firstID);
    final second = await studentRepository.getOneStudent(secondID);
    final store = first.positionNum;
    first.changePos = second.positionNum;
    second.positionNum = store;
    await studentRepository.updateStudent(first);
    await studentRepository.updateStudent(second);
  }
}
