import 'dart:async';
import 'package:lecture_performance_app/db/connect_db.dart';
import 'package:sqflite/sqflite.dart';
import '../db/models/Student.dart';

class StudentRepository {
  StudentRepository();

  Future<int> insertStudent(Student student) async {
    var db = await initDB();
    var id = await db.insert(
      'student',
      student.toMapNew(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Student>> getThisRoomStudent(int homeroomID) async {
    var db = await initDB();

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
    var db = await initDB();

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
    var db = await initDB();

    final List<Map<String, dynamic>> res = await db.query('student');
    List<Student> list =
        res.isNotEmpty ? res.map((c) => Student.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> deleteStudent(int id) async {
    var db = await initDB();

    await db.delete(
      'student',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateStudent(Student student) async {
    var db = await initDB();
    await db.update(
      'student',
      student.toMapNew(),
      where: "id = ?",
      whereArgs: [student.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}
