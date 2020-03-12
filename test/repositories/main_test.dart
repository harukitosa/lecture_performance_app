import './HomeRoom_test.dart';
import './Student_test.dart';
import './User_test.dart';
import './Semester_test.dart';
import './EvaluationType_test.dart';
import './Evaluation_test.dart';
import './Seat_test.dart';

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