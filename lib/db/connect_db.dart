import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initDB() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'database.db'),
    version: 1,
    onConfigure: _onConfigure,
    onCreate: _onCreate,
  );

  Database db = await database;

  return db;
}

_onConfigure(Database db) async {
  await db.execute("PRAGMA foreign_keys = ON");
}

_onCreate(Database db, int version) async {
  await _createTransaction(db);
}

_createTransaction(Database db) async {
  await db.transaction((txn) async {
    // CREATE USER
    await db.execute(
      '''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        password TEXT,
        email TEXT,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime'))
      )
      '''
    );

    // CREATE SEMESTER 
    await db.execute(
      '''
      CREATE TABLE semester(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        homeroom_id INTEGER,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        FOREIGN KEY (homeroom_id) REFERENCES homeroom (id) ON DELETE NO ACTION ON UPDATE NO ACTION
      )
      '''
    );

    // CREATE HOMEROOM
    await db.execute(
      '''
      CREATE TABLE homeroom(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        grade INTEGER,
        lectureClass INTEGER,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE NO ACTION ON UPDATE NO ACTION
      )
      '''
    );

    // CREATE STUDENT
    await db.execute(
      '''
      CREATE TABLE student(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        homeroom_id INTEGER,
        name TEXT,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        FOREIGN KEY (homeroom_id) REFERENCES homeroom (id) ON DELETE NO ACTION ON UPDATE NO ACTION
      )
      '''
    );

    // CREATE EVALUATION
    await db.execute(
      '''
      CREATE TABLE evaluation(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id INTEGER,
        type_id INTEGER,
        semester_id INTEGER,
        point INTEGER,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
        FOREIGN KEY (type_id) REFERENCES evaluation_type (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
        FOREIGN KEY (semester_id) REFERENCES semester (id) ON DELETE NO ACTION ON UPDATE NO ACTION
      )
      '''
    );

    //CREATE EVALUATION_TYPE
    await db.execute(
      '''
      CREATE TABLE evaluation_type(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime'))
      )
      '''
    );
  });
}