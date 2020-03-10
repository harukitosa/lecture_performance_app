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
  // Add support for cascade delete
  await db.execute("PRAGMA foreign_keys = ON");
}

_onCreate(Database db, int version) async {
  _createTransaction(db);
}

_createTransaction(Database db) async {
  await db.transaction((txn) async {
    // CREATE USER
    await db.execute(
      '''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTO INCREMENT,
        name TEXT,
        password TEXT,
        email TEXT,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
      )
      '''
    );

    // CREATE STUDENT
    await db.execute(
      '''
      CREATE TABLE student(
        id INTEGER PRIMARY KEY AUTO INCREMENT,
        FOREIGN KEY (homeroom_id) REFERENCES homeroom (id) ON DELETE NO ACTION ON UPDATE NO ACTION
        name TEXT,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
      )
      '''
    );

    // CREATE SEMESTER 
    await db.execute(
      '''
      CREATE TABLE semester(
        id INTEGER PRIMARY KEY AUTO INCREMENT,
        FOREIGN KEY (homeroom_id) REFERENCES homeroom (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
        title TEXT,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
      )
      '''
    );

    // CREATE HOMEROOM
    await db.execute(
      '''
      CREATE TABLE homeroom(
        id INTEGER PRIMARY KEY AUTO INCREMENT,
        FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
        grade INTEGER,
        lectureClass INTEGER,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
      )
      '''
    );

    // CREATE EVALUATION
    await db.execute(
      '''
      CREATE TABLE evaluation(
        id INTEGER PRIMARY KEY AUTO INCREMENT,
        FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
        FOREIGN KEY (type_id) REFERENCES evaluation_type (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
        FOREIGN KEY (semester_id) REFERENCES semester (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
        point INTEGER,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
      )
      '''
    );

    //CREATE EVALUATION_TYPE
    await db.execute(
      '''
      CREATE TABLE evaluation_type(
        id INTEGER PRIMARY KEY AUTO INCREMENT,
        title TEXT,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
      )
      '''
    );
  });
}