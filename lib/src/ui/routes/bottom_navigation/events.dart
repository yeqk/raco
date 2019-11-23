import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meta/meta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/repositories.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:intl/intl.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Events extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EventsState();
  }
}

class EventsState extends State<Events> with SingleTickerProviderStateMixin {
  RefreshController _refreshController;
  DateTime now;
  DateTime later;
  DateFormat parser;

  @override
  void initState() {
    now = DateTime.now();
    later = now.add(Duration(days: 90));
    parser = DateFormat('yyyy-M-dTH:m:s');
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat.Md(allTranslations.currentLanguage);
    return Container(
        child: Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: _eventsList(),
          ),
        )
      ],
    ));
  }

  List<Widget> _eventsList() {
    List<Widget> lista = new List();
    List<Event> events = Dme().events.results.where((e) {
      DateTime eTime = parser.parse(e.inici);
      return eTime.isAfter(now) && (e.nom == 'FESTIU' || e.nom == 'VACANCES' || e.nom == 'FESTA FIB' || e.nom == 'CANVI DIA');
    }).toList();
    List<EventItem> listEventItem = _createEventItemList();
    for (EventItem event in listEventItem) {
      DateTime eTime = parser.parse(event.inici);
      DateFormat eventTimeFormatter =
      DateFormat.yMMMMd(allTranslations.currentLanguage);
      if (event.examId == null) {
        lista.add(Card(
            child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(eventTimeFormatter.format(eTime)),
                  Divider(),
                  Text(event.title),
                ],
              ),
            )));
      }
      else {
          Examen examen = Dme().examens.results.firstWhere((e) => e.id == event.examId);
          String examString = '[' + examen.pla + '-' + examen.assig + '] ';
          DateFormat formatHour = DateFormat.Hm();
          String examTime = formatHour.format((parser.parse(examen.inici))) + '-' + formatHour.format((parser.parse(examen.fi)));
          if (examen.tipus == 'F') {
            examString += allTranslations.text('final_exam');
          } else {
            examString += allTranslations.text('midterm_exam');
          }
          lista.add(Card(
              child: Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(eventTimeFormatter.format(eTime)),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Text(examString),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        IconTheme(
                          data: IconThemeData(
                            color: Colors.grey,
                            size: ScreenUtil().setSp(15)
                          ),
                          child: Icon(Icons.access_time),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(5),
                        ),
                        Text(examTime)
                      ],
                    ),
                  ],
                ),
              )));
      }
    }
    return lista;
  }

  List<EventItem> _createEventItemList() {
    List<EventItem> resultList = new List();
    for(Event e in Dme().events.results) {
      DateTime eTime = parser.parse(e.inici);
      if (eTime.isAfter(now) && (e.nom == 'FESTIU' || e.nom == 'VACANCES' || e.nom == 'FESTA FIB' || e.nom == 'CANVI DIA')) {

        DateTime fiTime = parser.parse(e.fi);
        int difference = fiTime.difference(eTime).inDays;
        print('CCCCCC:' + e.nom + difference.toString());
        for (int i = 0; i <= difference; i ++) {
          DateTime iniciTime = eTime.add(Duration(days: i));
          resultList.add(EventItem(e.nom, parser.format(iniciTime), e.fi));
        }
      }
    }
    for (Examen exam in Dme().examens.results) {
      for (Assignatura a in Dme().assignatures.results) {
        if (exam.assig == a.sigles) {
          resultList.add(EventItem.exam(exam.id, exam.inici, exam.fi));
        }
      }
    }

    return resultList;
  }
}

class EventItem {
  int examId;
  String title;
  String description;
  String inici;
  bool custom = false;
  String fi;

  EventItem(this.title, this.inici, this.fi);
  EventItem.exam(this.examId, this.inici, this.fi);
}
