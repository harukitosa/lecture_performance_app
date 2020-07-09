import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lecture_performance_app/config/DataConfig.dart';

class DBManager {
  DBManager._internal();

  static Database _database;
  static final DBManager _dbManager = DBManager._internal();
  static DBManager get instance => _dbManager;

  Future<Database> initDB() async {
    if (_database != null) {
      return _database;
    }
    final database = openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );

    return _database = await database;
  }
}

Future<void> _onConfigure(Database db) async {
  await db.execute('PRAGMA foreign_keys = ON');
}

Future<void> _onCreate(Database db, int version) async {
  await _createTransaction(db);
}

Future<void> _createTransaction(Database db) async {
  await db.transaction((txn) async {
    // CREATE USER
    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        password TEXT,
        email TEXT,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime'))
      )
      ''');

    // CREATE HOMEROOM
    await db.execute('''
      CREATE TABLE homeroom(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        grade TEXT,
        lectureClass TEXT,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime'))
      )
      ''');

    // CREATE STUDENT
    await db.execute('''
      CREATE TABLE student(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        homeroom_id INTEGER,
        first_name TEXT,
        last_name TEXT,
        position_num INTEGER,
        number INTEGER,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        FOREIGN KEY (homeroom_id) REFERENCES homeroom (id) ON DELETE CASCADE ON UPDATE CASCADE
      )
      ''');

    // CREATE EVALUATION
    await db.execute('''
      CREATE TABLE evaluation(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id INTEGER,
        type_id INTEGER,
        point INTEGER,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        FOREIGN KEY (student_id) REFERENCES student (id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (type_id) REFERENCES evaluation_type (id) ON DELETE CASCADE ON UPDATE CASCADE
      )
      ''');

    //CREATE EVALUATION_TYPE
    await db.execute('''
      CREATE TABLE evaluation_type(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime'))
      )
      ''');

    //CREATE SEAT
    await db.execute('''
      CREATE TABLE seat(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        homeroom_id INTEGER,
        used TEXT,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        FOREIGN KEY (homeroom_id) REFERENCES homeroom (id) ON DELETE CASCADE ON UPDATE CASCADE
      )
      ''');

    await _insertSeatTransaction(db);
  });
}

Future<void> _insertSeatTransaction(Database db) async {
  final config = AppDataConfig();
  await db.transaction((txn) async {
    final id = await txn.rawInsert('''
        INSERT INTO homeroom(grade, lectureClass) VALUES('1', '1')
      ''');
    for (var i = 0; i < config.seatNum; i++) {
      await txn.rawInsert('''
          INSERT INTO seat(homeroom_id, used) VALUES($id, 'true')
        ''');
    }
    for (var i = 0; i < config.seatNum; i++) {
      await txn.rawInsert('''
          INSERT INTO student(homeroom_id, first_name, last_name, position_num, number) VALUES($id, $i, $i, $i, $i)
        ''');
    }
    await txn.rawInsert('''
      INSERT INTO evaluation_type(title) VALUES('回答')
    ''');
    await txn.rawInsert('''
      INSERT INTO evaluation_type(title) VALUES('積極性')
    ''');
  });
}
