import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/models/db_helpers/schedule_helper.dart';
import 'package:raco/src/models/db_helpers/user_helper.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/models/requisits.dart';
import 'package:sqflite/sqflite.dart';
import 'raco_api_client.dart';

class DbRepository {
  Database db;
  final String databaseName = 'raco_db.db';

  final String userTable = 'user';
  final String scheduleTable = "schedule";

  //Singleton
  DbRepository._internal();
  static final DbRepository _dbRepository = DbRepository._internal();
  factory DbRepository() {
    return _dbRepository;
  }

  Future openDB() async {

    db = await openDatabase(databaseName, version: 1, onCreate: (Database db, int version) async {

      await db.execute('''
      create table $userTable (
        assignatures text,
        avisos text,
        classes text,
        foto text,
        practiques text,
        projectes text,
        username text primary key,
        nom text,
        cognoms text,
        email text,
        avatarPath text)
      ''');

      await db.execute('''
      create table $scheduleTable (
        id integer primary key autoincrement,
        username text,
        codiAssig text,
        grup text,
        diaSetmana integer,
        inici text,
        durada integer,
        tipus text,
        aules text,
        foreign key(username) references $userTable(username))
      ''');


    });
  }

  Future closeDB() async{
    db.close();
  }

  Future deleteDB() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + '/'+  databaseName;
    await deleteDatabase(path);
  }

  Future insertMeHelper(UserHelper userHelper) async {
    await db.insert(userTable, userHelper.toMap());
  }

  Future<UserHelper> getMeHelper() async {
    List<Map> maps = await db.query(userTable);
    if (maps.length > 0) {
      return UserHelper.fromMap(maps.first);
    }
    return null;
  }

  Future insertScheduleHelper(ScheduleHelper scheduleHelper) async {
    await db.insert(scheduleTable, scheduleHelper.toMap());
  }

  Future<List<ScheduleHelper>> getAllScheduleHelper() async {
    List<Map> maps = await db.query(scheduleTable);
    List<ScheduleHelper> allResults = List();
    maps.forEach((map) {
      allResults.add(ScheduleHelper.fromMap(map));
    });
    return allResults;
  }

}
DbRepository dbRepository = DbRepository();
