import 'package:lecture_performance_app/repositories/Student.dart';
import '../db/models/Student.dart';
import '../utility/time.dart';
class StudentService {

  final StudentRepository studentRepository;
  StudentService({
    this.studentRepository
  });

  Future<List<Student>> getRoomStudents(int homeroomID) async {
    return await studentRepository.getThisRoomStudent(homeroomID);
  } 

  Future<int> createstudent(int homeRoomID, String name, int number) async {
    var students = await studentRepository.getThisRoomStudent(homeRoomID);
    var maxPosition = 0;
    for(var i = 0;i < students.length;i++) {
      if(maxPosition < students[i].positionNum) {
        maxPosition = students[i].positionNum;
      }
    }
    var student = new Student(homeRoomID: homeRoomID, name: name, positionNum: maxPosition+1, number: number);
    var id = studentRepository.insertStudent(student);
    return id;
  }

  Future<void> editstudent(int id, int homeRoomID, int positionNum, String name, int number, String createTime) {
    var student = new Student(
      id: id, 
      homeRoomID: homeRoomID,
      positionNum: positionNum, 
      number: number,
      name: name,
      createTime: createTime,
      updateTime: getNowTime(),
    );
    return studentRepository.updateStudent(student);
  }

  Future<void> deletestudent(int id) {
    return studentRepository.deleteStudent(id);
  }
}