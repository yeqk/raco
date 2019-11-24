import 'dart:collection';
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
import 'package:raco/src/models/custom_events.dart';
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
  DateFormat eventTimeFormatter ;
  DateFormat dateFormat;

  @override
  void initState() {
    dateFormat = DateFormat.yMd();
    eventTimeFormatter =
        DateFormat.yMMMMd(allTranslations.currentLanguage);
    parser = DateFormat('yyyy-M-dTH:m:s');
    now = DateTime.now();
    later = now.add(Duration(days: 90));
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

    List<EventItem> listEventItem = _createEventItemList();
    Map<String, List<EventItem>> itemMap = _mapEventItemList(listEventItem);

    List<String> sortedKeys = itemMap.keys.toList()..sort((a, b) {
      DateTime ta = dateFormat.parse(a);
      DateTime tb = dateFormat.parse(b);
      return ta.compareTo(tb);
    });

    for(String kDate in sortedKeys) {
      DateFormat.yMMMMd(allTranslations.currentLanguage);
      lista.add(Card(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _textItems(kDate,itemMap[kDate]),
            ),
          )));
    }
    return lista;
  }

  List<Widget> _textItems(String kDate,List<EventItem> items) {
    List<Widget> resultList = new List();
    resultList.add(Text(eventTimeFormatter.format(dateFormat.parse(kDate))));
    resultList.add(Divider(thickness: 3,));
    for(EventItem i in items) {
      if (i.isCustom) {
        resultList.add(FittedBox(
          child: Row(
            children: <Widget>[
              IconTheme(
                data: IconThemeData(
                    color: Colors.grey,
                    size: ScreenUtil().setSp(15)
                ),
                child: Icon(Icons.person),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(10),
              ),
              Text(i.title),
              _timeRow(i)
            ],
          ),
        ));
      } else if (i.examId != null) {
        Examen examen = Dme().examens.results.firstWhere((e) => e.id == i.examId);
        String examString = '[' + examen.pla + '-' + examen.assig + '] ';
        if (examen.tipus == 'F') {
          examString += allTranslations.text('final_exam');
        } else {
          examString += allTranslations.text('midterm_exam');
        }
        if (examen.eslaboratori == 'S') {
          examString += ' (Lab)';
        }
        resultList.add(Row(
          children: <Widget>[
            Text(examString),
            _timeRow(i)
          ],
        ),);
      } else if (i.title != null){
        resultList.add(Row(
          children: <Widget>[
            Text(i.title),
            _timeRow(i)
          ],
        ),);
      } else {
        resultList.add(Text('ERROR'));
      }
      resultList.add(Divider(thickness: 1,));
    }
    return resultList;
  }

  Widget _timeRow(EventItem eventItem) {
    if (_sameDay(parser.parse(eventItem.inici), parser.parse(eventItem.fi))) {
      DateFormat formatHour = DateFormat.Hm();
      String duration = formatHour.format((parser.parse(eventItem.inici))) + '-' + formatHour.format((parser.parse(eventItem.fi)));
      return Row(
        children: <Widget>[
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
          Text(duration)
        ],
      );
    }
    return SizedBox(
      width: 0,
      height: 0,
    );
  }

  bool _sameDay(DateTime a, DateTime b) {
    print('checking: ' + a.toIso8601String() + ' with ' + b.toIso8601String());
    int diffDay = a.difference(b).inDays;
    bool same = (diffDay == 0 && a.day == b.day);
    print('diff days: ' + diffDay.toString() + ' same=> ' + same.toString());
    return same;
  }

  Map<String, List<EventItem>> _mapEventItemList(List<EventItem> eventItemList) {
    Map<String, List<EventItem>> itemMap = HashMap();
    for (EventItem item in eventItemList) {
       if (itemMap.containsKey(item.data)) {
         itemMap[item.data].add(item);
      } else {
        itemMap[item.data] = new List();
        itemMap[item.data].add(item);
      }
    }

    return itemMap;
  }

  List<EventItem> _createEventItemList() {

    List<EventItem> resultList = new List();
    for(Event e in Dme().events.results) {
      DateTime fiTime = parser.parse(e.fi);
      if (fiTime.isAfter(now) && (e.nom == 'FESTIU' || e.nom == 'VACANCES' || e.nom == 'FESTA FIB' || e.nom == 'CANVI DIA')) {
        DateTime iniTime = parser.parse(e.inici);
        int difference = fiTime.difference(iniTime).inDays;
        for (int i = 0; i <= difference; i ++) {
          DateTime iniciTime = iniTime.add(Duration(days: i));
          resultList.add(EventItem(e.nom, e.inici, e.fi,dateFormat.format(iniciTime) ));
        }
      }
    }

    for (Examen exam in Dme().examens.results) {
      for (Assignatura a in Dme().assignatures.results) {
        if (exam.assig == a.sigles) {
          DateTime eTime = parser.parse(exam.inici);
          DateTime fiTime = parser.parse(exam.fi);
          int difference = fiTime.difference(eTime).inDays;
          for (int i = 0; i <= difference; i ++) {
            DateTime iniciTime = eTime.add(Duration(days: i));
            resultList.add(EventItem.exam(exam.id, exam.inici, exam.fi, dateFormat.format(iniciTime)));
          }
        }
      }
    }

    for (CustomEvent ce in Dme().customEvents.results) {
      DateTime eTime = parser.parse(ce.inici);
      DateTime fiTime = parser.parse(ce.fi);
      int difference = fiTime.difference(eTime).inDays;
      for (int i = 0; i <= difference; i ++) {
        DateTime iniciTime = eTime.add(Duration(days: i));
        resultList.add(EventItem.custom(ce.title, ce.description, ce.inici, ce.fi, dateFormat.format(iniciTime)));
      }
    }

    resultList.sort((a, b) {
      DateTime ta = dateFormat.parse(a.data);
      DateTime tb = dateFormat.parse(b.data);
      return ta.compareTo(tb);
    });

    return resultList;
  }
}

class EventItem {
  int examId;
  String title;
  String description;
  String data;
  String inici;
  bool isCustom = false;
  String fi;

  EventItem(this.title, this.inici, this.fi, this.data);
  EventItem.exam(this.examId, this.inici, this.fi, this.data);
  EventItem.custom(this.title, this.description, this.inici, this.fi, this.data):this.isCustom = true;
}
