import 'repositories/HomeRoom_test.dart';
import 'repositories/Student_test.dart';
import 'repositories/User_test.dart';
import 'repositories/Semester_test.dart';
import 'repositories/EvaluationType_test.dart';
import 'repositories/Evaluation_test.dart';
import 'repositories/Seat_test.dart';

void main() {
  //REPOSITORY TEST
    testUserRepository();
    testHomeRoomRepository();
    testStudentRepository();
    testSemesterRepository();
    testEvaluationTypeRepository();
    testEvaluationRepository();
    testSeatRepository();
}