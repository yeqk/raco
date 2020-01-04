import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/models/db_helpers/attachment_helper.dart';
import 'package:raco/src/models/db_helpers/custom_event_helper.dart';
import 'package:raco/src/models/db_helpers/custom_grade_helper.dart';
import 'package:raco/src/models/db_helpers/event_helper.dart';
import 'package:raco/src/models/db_helpers/exam_helper.dart';
import 'package:raco/src/models/db_helpers/lab_image_helper.dart';
import 'package:raco/src/models/db_helpers/news_helper.dart';
import 'package:raco/src/models/db_helpers/notice_helper.dart';
import 'package:raco/src/models/db_helpers/schedule_helper.dart';
import 'package:raco/src/models/db_helpers/subject_helper.dart';
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
  final String noticeTable = "notice";
  final String attachmentTable = "attachment";
  final String eventTable = "event";
  final String newsTable = "news";
  final String subjectTable = "subject";
  final String examTable = "exam";
  final String labImageTable = "imageLab";
  final String customEventTable = "customEvent";
  final String customGradeTable = "customGrade";

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

      await db.execute('''
      create table $noticeTable (
        id integer primary key,
        titol text,
        codiAssig text,
        textContent text,
        dataInsercio text,
        dataModificacio text,
        dataCaducitat text,
        username text,
        foreign key(username) references $userTable(username))
      ''');

      await db.execute('''
      create table $attachmentTable (
        id integer primary key autoincrement,
        tipusMime text,
        nom text,
        url text,
        dataModificacio text,
        mida integer,
        noticeId integer,
        foreign key(noticeId) references $noticeTable(id))
      ''');

      await db.execute('''
      create table $eventTable (
        id integer primary key autoincrement,
        nom text,
        inici text,
        fi text)
      ''');

      await db.execute('''
      create table $newsTable (
        id integer primary key autoincrement,
        titol text,
        link text,
        descripcio text,
        dataPublicacio text)
      ''');

      await db.execute('''
      create table $subjectTable (
        id text primary key,
        url text,
        guia text,
        grup text,
        sigles text,
        codiUPC integer,
        semestre text,
        credits real,
        nom text,
        username text,
        foreign key(username) references $userTable(username))
      ''');

      await db.execute('''
      create table $examTable (
        altid integer primary key autoincrement,
        id integer,
        assig text,
        aules text,
        inici text,
        fi text,
        quatr integer,
        curs integer,
        pla text,
        tipus text,
        comentaris text,
        eslaboratori text,
        username text,
        foreign key(username) references $userTable(username))
      ''');

      await db.execute('''
      create table $labImageTable (
        name text primary key,
        path text)
      ''');

      await db.execute('''
      create table $customEventTable (
        id text primary key,
        title text,
        description text,
        inici text,
        fi text,
        username text,
        foreign key(username) references $userTable(username))
      ''');

      await db.execute('''
      create table $customGradeTable (
        id text primary key,
        subjectId text,
        name text,
        comments text,
        data text,
        grade real,
        percentage real,
        username text,
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
    if (await File(path).exists()) {
      await deleteDatabase(path);
    }
  }

  //me
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

  //schedule

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

  //notice
  Future insertNoticeHelper(NoticeHelper noticeHelper) async {
    await db.insert(noticeTable, noticeHelper.toMap());
  }

  Future<List<NoticeHelper>> getAllNoticeHelper() async {
    List<Map> maps = await db.query(noticeTable);
    List<NoticeHelper> allResults = List();
    maps.forEach((map) {
      allResults.add(NoticeHelper.fromMap(map));
    });
    return allResults;
  }

  Future clearNoticeHelperTalbe() async {
    await db.delete(noticeTable);
  }

  //attachment
  Future insertAttachmentHelper(AttachmentHelper attachmentHelper) async {
    await db.insert(attachmentTable, attachmentHelper.toMap());
  }



  Future<List<AttachmentHelper>> getAllAttachmentHelper() async {
    List<Map> maps = await db.query(attachmentTable);
    List<AttachmentHelper> allResults = List();
    maps.forEach((map) {
      allResults.add(AttachmentHelper.fromMap(map));
    });
    return allResults;
  }

  Future<List<AttachmentHelper>> getAttachmentHelperByNoticeId(int noticeId) async {
    List<Map> maps = await db.query(attachmentTable, where: "noticeId = ?", whereArgs: [noticeId]);
    List<AttachmentHelper> allResults = List();
    maps.forEach((map) {
      allResults.add(AttachmentHelper.fromMap(map));
    });
    return allResults;
  }

  Future clearAttachmentHelperTable() async {
    await db.delete(attachmentTable);
  }

  //event
  Future insertEventHelper(EventHelper eventhmentHelper) async {
    await db.insert(eventTable, eventhmentHelper.toMap());
  }

  Future<List<EventHelper>> getAllEventHelper() async {
    List<Map> maps = await db.query(eventTable);
    List<EventHelper> allResults = List();
    maps.forEach((map) {
      allResults.add(EventHelper.fromMap(map));
    });
    return allResults;
  }

  Future clearEventHelperTable() async {
    await db.delete(eventTable);
  }

  //news
  Future insertNewsHelper(NewsHelper eventhmentHelper) async {
    await db.insert(newsTable, eventhmentHelper.toMap());
  }

  Future<List<NewsHelper>> getAllNewsHelper() async {
    List<Map> maps = await db.query(newsTable);
    List<NewsHelper> allResults = List();
    maps.forEach((map) {
      allResults.add(NewsHelper.fromMap(map));
    });
    return allResults;
  }

  Future clearNewsHelperTable() async {
    await db.delete(newsTable);
  }

  //subjects
  Future insertSubjectHelper(SubjectHelper subjectHelper) async {
    await db.insert(subjectTable, subjectHelper.toMap());
  }

  Future<List<SubjectHelper>> getAllSubjectHelper() async {
    List<Map> maps = await db.query(subjectTable);
    List<SubjectHelper> allResults = List();
    maps.forEach((map) {
      allResults.add(SubjectHelper.fromMap(map));
    });
    return allResults;
  }

  //exams
  Future insertExamtHelper(ExamHelper examHelper) async {
    await db.insert(examTable, examHelper.toMap());
  }

  Future<List<ExamHelper>> getAllExamHelper() async {
    List<Map> maps = await db.query(examTable);
    List<ExamHelper> allResults = List();
    maps.forEach((map) {
      allResults.add(ExamHelper.fromMap(map));
    });
    return allResults;
  }

  //lab image
  Future insertLabImage(LabImageHelper labImageHelper) async {
    await db.insert(labImageTable, labImageHelper.toMap());
  }

  Future<String> getLabImagePathByName(String name) async {
    List<Map> maps = await db.query(labImageTable, where: "name = ?", whereArgs: [name]);
    return maps.first['path'];
  }

  Future updateLabImage(LabImageHelper labImageHelper) async {
    await db.update(labImageTable, labImageHelper.toMap(), where: "name = ?", whereArgs: [labImageHelper.name]);
  }

  //custom event
  Future<List<CustomEventHelper>> getAllCustomEventHelper() async {
    List<Map> maps = await db.query(customEventTable);
    List<CustomEventHelper> allResults = List();
    maps.forEach((map) {
      allResults.add(CustomEventHelper.fromMap(map));
    });
    return allResults;
  }

  Future insertCustomEventHelper(CustomEventHelper customEventHelper) async {
    await db.insert(customEventTable, customEventHelper.toMap());
  }

  Future deleteCustomerEventById(String idTodelete) async {
    await db.delete(customEventTable, where: "id = ?", whereArgs: [idTodelete]);
  }

/*  Future updateCustomerEventById(CustomEventHelper customEventHelper) async {
    await db.update(customEventTable, customEventHelper.toMap(), where: "id = ?", whereArgs: [customEventHelper.id]);
  }
  */
  Future clearCustomEventHelperTable() async {
    await db.delete(customEventTable);
  }

  //custom grade
  Future<List<CustomGradeHelper>> getAllCustomGradeHelper() async {
    List<Map> maps = await db.query(customGradeTable);
    List<CustomGradeHelper> allResults = List();
    maps.forEach((map) {
      allResults.add(CustomGradeHelper.fromMap(map));
    });
    return allResults;
  }

  Future insertCustomGradeHelper(CustomGradeHelper customGradeHelper) async {
    await db.insert(customGradeTable, customGradeHelper.toMap());
  }

  Future deleteCustomGradeById(String idTodelete) async {
    await db.delete(customGradeTable, where: "id = ?", whereArgs: [idTodelete]);
  }

  Future clearCustomGradeHelperTable() async {
    await db.delete(customGradeTable);
  }
}
DbRepository dbRepository = DbRepository();
