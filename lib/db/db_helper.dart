import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? db;
  static const int _version = 1;
  static const String _tableName = 'task';

  static Future<void> initDb() async {
    if (db != null) {
      debugPrint('not null db');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'task.db';
        debugPrint('in database path');
        db = await openDatabase(_path, version: _version,
            onCreate: (db, version) async {
          debugPrint('create  database path');
          // When creating the db, create the table
          return await db.execute(
            "CREATE TABLE $_tableName ("
            "id INTEGER PRIMARY KEY,"
            "title STRING, note TEXT,date STRING"
            "startTime STRING,endTime STRING,"
            "remind INTEGER,repeat STRING,"
            "color INTEGER,"
            "isCompleted INTEGER)",
          );
        });
        // print('DataBase CREATED');
      } catch (e) {
        print('$e Data  base NOT CREATED');
      }
    }
  }

  static Future<int> insert(Task? task) async {
    print('insert function called');
    try {
      print('we are here ');
      return await db?.insert(_tableName, task!.toJson()) ?? 1;
    } catch (e) {
      print('we are here ');
      return 90000;
    }
  }

  static Future<int> delete(Task task) async {
    print('delete function called');
    return await db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static Future<int> deleteAll() async {
    print('deleteAll function called');
    return await db!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('query function called');
    return await db!.query(_tableName);
  }

  static update(int id) async {
    print('Update function called ');
    return await db!.rawUpdate(''' 
    UPDATE task
    SET isCompleted = ?
    WHERE id = ?

    ''', [1, id]);
  }
}
