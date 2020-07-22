import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:lecture_performance_app/db/models/student.dart';
import 'package:lecture_performance_app/repositories/student_repository.dart';
import 'package:sqflite/sqflite.dart';

IStudentRepository newStudentRepository() {
  return StudentRepository();
}

class StudentRepository extends IStudentRepository {
  StudentRepository();

  @override
  Future<int> insertStudent(Student student) async {
    Database db;
    db = await DBManager.instance.initDB();
    final id = await db.insert(
      'student',
      student.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  @override
  Future<List<Student>> getThisRoomStudent(int homeroomID) async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    final args = [homeroomID];
    res = await db.query(
      'student',
      where: 'homeroom_id = ?',
      whereArgs: args,
      orderBy: 'number ASC',
    );
    return res.isNotEmpty ? res.map((c) => Student.fromMap(c)).toList() : [];
  }

  @override
  Future<Student> getOneStudent(int id) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [id];
    List<Map<String, dynamic>> res;
    res = await db.query(
      'student',
      where: 'id = ?',
      whereArgs: args,
    );
    List<Student> list;
    list = res.isNotEmpty ? res.map((c) => Student.fromMap(c)).toList() : [];
    return list[0];
  }

  @override
  Future<List<Student>> getAllStudents() async {
    Database db;
    db = await DBManager.instance.initDB();
    List<Map<String, dynamic>> res;
    res = await db.query('student');
    return res.isNotEmpty ? res.map((c) => Student.fromMap(c)).toList() : [];
  }

  @override
  Future<void> deleteStudent(int id) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [id];
    await db.delete(
      'student',
      where: 'id = ?',
      whereArgs: args,
    );
  }

  @override
  Future<void> updateStudent(Student student) async {
    Database db;
    db = await DBManager.instance.initDB();
    final args = [student.id];
    await db.update(
      'student',
      student.toMapNew(),
      where: 'id = ?',
      whereArgs: args,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
