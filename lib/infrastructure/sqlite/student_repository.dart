import 'package:lecture_performance_app/repositories/student_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lecture_performance_app/db/models/Student.dart';
import 'package:lecture_performance_app/db/connect_db.dart';

IStudentRepository newStudentRepository() {
  return new StudentRepository();
}

class StudentRepository extends IStudentRepository {
  StudentRepository();

  Future<int> insertStudent(Student student) async {
    Database db = await DBManager.instance.initDB();
    var id = await db.insert(
      'student',
      student.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Student>> getThisRoomStudent(int homeroomID) async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query(
      "student",
      where: "homeroom_id = ?",
      whereArgs: [homeroomID],
      orderBy: "number DESC",
    );
    List<Student> list =
        res.isNotEmpty ? res.map((c) => Student.fromMap(c)).toList() : [];
    return list;
  }

  Future<Student> getOneStudent(int id) async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query(
      "student",
      where: "id = ?",
      whereArgs: [id],
    );
    List<Student> list =
        res.isNotEmpty ? res.map((c) => Student.fromMap(c)).toList() : [];
    return list[0];
  }

  Future<List<Student>> getAllStudents() async {
    Database db = await DBManager.instance.initDB();
    final List<Map<String, dynamic>> res = await db.query('student');
    List<Student> list =
        res.isNotEmpty ? res.map((c) => Student.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteStudent(int id) async {
    Database db = await DBManager.instance.initDB();
    await db.delete(
      'student',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateStudent(Student student) async {
    Database db = await DBManager.instance.initDB();
    await db.update(
      'student',
      student.toMapNew(),
      where: "id = ?",
      whereArgs: [student.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
