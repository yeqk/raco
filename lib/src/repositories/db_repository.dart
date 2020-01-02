import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/models/requisits.dart';
import 'package:sqflite/sqflite.dart';
import 'raco_api_client.dart';

class DbRepository {
  Database db;
  final String databaseName = 'raco_db.db';
  final String meTable = 'me';

  //Singleton
  DbRepository._internal();
  static final DbRepository _dbRepository = DbRepository._internal();
  factory DbRepository() {
    return _dbRepository;
  }

  Future openDB() async {

    db = await openDatabase(databaseName, version: 1, onCreate: (Database db, int version) async {

      await db.execute('''
      create table $meTable (
        assignatures text,
        avisos text,
        classes text,
        foto text,
        practiques text,
        projectes text,
        username text primary key,
        nom text,
        cognoms text,
        email text)
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

  Future insertMe(Me me) async {
    await db.insert(meTable, me.toMap());
  }

  Future<Me> getMe() async {
    print('hhhh');
    List<Map> maps = await db.query(meTable);
    if (maps.length > 0) {
      return Me.fromMap(maps.first);
    }
  }

}
DbRepository dbRepository = DbRepository();
