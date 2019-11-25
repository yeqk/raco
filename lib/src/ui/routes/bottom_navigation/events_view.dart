import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meta/meta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:raco/flutter_datetime_picker-1.2.8-with-ca/flutter_datetime_picker.dart';
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

class EventsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EventsViewState();
  }
}

class EventsViewState extends State<EventsView>
    with SingleTickerProviderStateMixin {
  RefreshController _refreshController;
  DateFormat parser;
  DateFormat eventTimeFormatter;
  DateFormat dateFormat;
  DateFormat dateFormatWithHour;

  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _startDateController;
  TextEditingController _endDateController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    dateFormat = DateFormat.yMd(allTranslations.currentLanguage);
    dateFormatWithHour =
        DateFormat.yMd(allTranslations.currentLanguage).add_Hm();
    eventTimeFormatter = DateFormat.yMMMMd(allTranslations.currentLanguage);
    parser = DateFormat('yyyy-MM-ddTHH:mm:ss');

    _refreshController = RefreshController(initialRefresh: false);

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _startDateController = TextEditingController();
    _startDateController.text = dateFormatWithHour.format(DateTime.now());
    _endDateController = TextEditingController();
    _endDateController.text = dateFormatWithHour.format(DateTime.now());

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
        child: SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: BezierCircleHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView(
        children: _eventsList(context, setState),
      ),
    ));
  }

  void _onRefresh() async {
    //update events
    String accessToken = await user.getAccessToken();
    String lang = await user.getPreferredLanguage();
    RacoRepository rr = new RacoRepository(
        racoApiClient: RacoApiClient(
            httpClient: http.Client(), accessToken: accessToken, lang: lang));
    Events events = await rr.getEvents();
    await ReadWriteFile()
        .writeStringToFile(FileNames.EVENTS, jsonEncode(events));
    Dme().events = events;
    setState(() {});
    _refreshController.refreshCompleted();
  }

  List<Widget> _eventsList(BuildContext context, StateSetter setState) {
    List<Widget> lista = new List();

    List<EventItem> listEventItem = _createEventItemList();
    Map<String, List<EventItem>> itemMap = _mapEventItemList(listEventItem);

    List<String> sortedKeys = itemMap.keys.toList()
      ..sort((a, b) {
        DateTime ta = dateFormat.parse(a);
        DateTime tb = dateFormat.parse(b);
        return ta.compareTo(tb);
      });

    for (String kDate in sortedKeys) {
      DateFormat.yMMMMd(allTranslations.currentLanguage);
      lista.add(Card(
        child: InkWell(
            onTap: () => _onTap(kDate, itemMap[kDate]),
            child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _textItems(kDate, itemMap[kDate]),
              ),
            )),
      ));
    }
    return lista;
  }

  _onTap(String kDate, List<EventItem> itemsList) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                content: Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FittedBox(
                          child: Text(
                            eventTimeFormatter.format(dateFormat.parse(kDate)),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          thickness: ScreenUtil().setSp(5),
                        ),
                        Expanded(
                          child: ListView(
                            children:
                                _itemsExpanded(itemsList, setState, kDate),
                          ),
                        ),
                      ],
                    )),
              );
            },
          );
        });
  }

  List<Widget> _itemsExpanded(
      List<EventItem> itemsList, StateSetter setState, String kDate) {
    List<Widget> resultList = new List();
    for (EventItem i in itemsList) {
      if (i.isCustom) {
        resultList.add(Row(
          children: <Widget>[
            Expanded(
                child: Text(
              i.title,
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.visible,
            )),
            _simplePopup(i, setState, itemsList, kDate)
          ],
        ));
      } else if (i.examId != null) {
        Examen examen =
            Dme().examens.results.firstWhere((e) => e.id == i.examId);
        resultList.add(Row(
          children: <Widget>[
            Expanded(
              child: Text(
                _examString(examen),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
      } else if (i.title != null) {
        resultList.add(Row(
          children: <Widget>[
            Expanded(
              child: Text(
                i.title,
                overflow: TextOverflow.visible,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
      } else {
        resultList.add(Text('ERROR'));
      }
      resultList.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FittedBox(
            child: Text(
              allTranslations.text('start') +
                  ': ' +
                  dateFormatWithHour.format(parser.parse(i.inici)),
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ));
      resultList.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FittedBox(
            child: Text(
              allTranslations.text('end') +
                  ': ' +
                  dateFormatWithHour.format(parser.parse(i.fi)),
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        ],
      ));
      if (i.description != null && i.description != '') {
        resultList.add(Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(2)),
          color: Colors.black12,
          child: Text(i.description),
        ));
      }
      resultList.add(Divider(
        thickness: ScreenUtil().setSp(1),
      ));
    }

    return resultList;
  }

  Widget _simplePopup(
          EventItem item, StateSetter po, List<EventItem> li, String kDate) =>
      PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Row(
              children: <Widget>[
                Icon(Icons.edit),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                Text(allTranslations.text('edit'))
              ],
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: <Widget>[
                Icon(Icons.delete),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                Text(allTranslations.text('delete'))
              ],
            ),
          ),
        ],
        onSelected: (value) async {
          if (value == 2) {
            Dme().customEvents.results.removeWhere((i) {
              return i.id == item.customId;
            });
            Dme().customEvents.count -= 1;
            await ReadWriteFile().writeStringToFile(
                FileNames.CUSTOM_EVENTS, jsonEncode(Dme().customEvents));
            li.removeWhere((i) {
              return i.customId == item.customId;
            });
            po(() {});
            setState(() {});
          } else if (value == 1) {
            _buttonPressed(item, li, kDate, po);
          }
        },
      );

  void _buttonPressed(
      EventItem item, List<EventItem> li, String kDate, StateSetter po) {
    _titleController.text = item.title;
    _descriptionController.text = item.description;
    _startDateController.text =
        dateFormatWithHour.format(parser.parse(item.inici));
    _endDateController.text = dateFormatWithHour.format(parser.parse(item.fi));

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width / 1.5,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new TextFormField(
                                  controller: _titleController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return allTranslations
                                          .text('empty_field_error');
                                    }
                                    return null;
                                  },
                                  decoration: new InputDecoration(
                                    labelText: "Title",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                                new TextFormField(
                                  controller: _descriptionController,
                                  maxLines: 3,
                                  maxLength: 320,
                                  decoration: new InputDecoration(
                                    labelText: "Description",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  keyboardType: TextInputType.multiline,
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                                InkWell(
                                  onTap: () {
                                    _selectStartDate(); // Call Function that has showDatePicker()
                                  },
                                  child: IgnorePointer(
                                    child: new TextFormField(
                                      controller: _startDateController,
                                      decoration: new InputDecoration(
                                        labelText:
                                            allTranslations.text('start_date'),
                                        fillColor: Colors.white,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(20.0),
                                          borderSide: new BorderSide(),
                                        ),
                                      ),
                                      // validator: validateDob,
                                      onSaved: (String val) {},
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                                InkWell(
                                  onTap: () {
                                    _selectEndDate(); // Call Function that has showDatePicker()
                                  },
                                  child: IgnorePointer(
                                    child: new TextFormField(
                                      controller: _endDateController,
                                      decoration: new InputDecoration(
                                        labelText:
                                            allTranslations.text('end_date'),
                                        fillColor: Colors.white,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(20.0),
                                          borderSide: new BorderSide(),
                                        ),
                                      ),
                                      // validator: validateDob,
                                      onSaved: (String val) {},
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          OutlineButton(
                              child: Text(allTranslations.text('cancel')),
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          OutlineButton(
                              child: Text(allTranslations.text('save')),
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  DateTime ini = dateFormatWithHour
                                      .parse(_startDateController.text);
                                  DateTime fiT = dateFormatWithHour
                                      .parse(_endDateController.text);
                                  Dme().customEvents.results.removeWhere((i) {
                                    return i.id == item.customId;
                                  });
                                  li.removeWhere((i) {
                                    return i.customId == item.customId;
                                  });
                                  String customId =
                                      DateTime.now().toIso8601String();

                                  Dme().customEvents.results.add(CustomEvent(
                                      customId,
                                      _titleController.text,
                                      _descriptionController.text,
                                      parser.format(ini),
                                      parser.format(fiT)));
                                  await ReadWriteFile().writeStringToFile(
                                      FileNames.CUSTOM_EVENTS,
                                      jsonEncode(Dme().customEvents));
                                  DateTime groupTime = dateFormat.parse(kDate);

                                  if (groupTime.year >= ini.year &&
                                      groupTime.year <= fiT.year &&
                                      groupTime.month >= ini.month &&
                                      groupTime.month <= fiT.month &&
                                      groupTime.day >= ini.day &&
                                      groupTime.day <= fiT.day) {
                                    li.add(EventItem.custom(
                                        _titleController.text,
                                        _descriptionController.text,
                                        parser.format(ini),
                                        parser.format(fiT),
                                        kDate,
                                        customId));
                                  }

                                  po(() {});
                                  setState(() {});
                                  Navigator.of(context).pop();
                                }
                              })
                        ])
                  ],
                )),
          );
        });
  }

  void _selectStartDate() async {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(Duration(days: 730)), onChanged: (date) {
      if (date.isAfter(dateFormatWithHour.parse(_endDateController.text))) {
        _endDateController.text = dateFormatWithHour.format(date);
      }
      _startDateController.text = dateFormatWithHour.format(date);
    }, onConfirm: (date) {
      if (date.isAfter(dateFormatWithHour.parse(_endDateController.text))) {
        _endDateController.text = dateFormatWithHour.format(date);
      }
      _startDateController.text = dateFormatWithHour.format(date);
    },
        currentTime: dateFormatWithHour
            .parse(_startDateController.text)
            .add(Duration(minutes: 1)),
        locale: LocaleType.ca);
  }

  void _selectEndDate() async {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(Duration(days: 730)), onChanged: (date) {
      if (date.isBefore(dateFormatWithHour.parse(_startDateController.text))) {
        _startDateController.text = dateFormatWithHour.format(date);
      }
      _endDateController.text = dateFormatWithHour.format(date);
    }, onConfirm: (date) {
      if (date.isBefore(dateFormatWithHour.parse(_startDateController.text))) {
        _startDateController.text = dateFormatWithHour.format(date);
      }
      _endDateController.text = dateFormatWithHour.format(date);
    },
        currentTime: dateFormatWithHour
            .parse(_endDateController.text)
            .add(Duration(minutes: 1)),
        locale: LocaleType.ca);
  }

  List<Widget> _textItems(String kDate, List<EventItem> items) {
    List<Widget> resultList = new List();
    if (eventTimeFormatter.format(DateTime.now()) ==
        eventTimeFormatter.format(dateFormat.parse(kDate))) {
      resultList.add(Text(
        allTranslations.text('today') +
            ' ' +
            eventTimeFormatter.format(dateFormat.parse(kDate)),
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
    } else {
      resultList.add(Text(eventTimeFormatter.format(dateFormat.parse(kDate))));
    }

    resultList.add(Divider(
      thickness: ScreenUtil().setSp(3),
    ));
    for (EventItem i in items) {
      if (i.isCustom) {
        resultList.add(FittedBox(
          child: Row(
            children: <Widget>[
              IconTheme(
                data: IconThemeData(
                    color: Colors.grey, size: ScreenUtil().setSp(15)),
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
        Examen examen =
            Dme().examens.results.firstWhere((e) => e.id == i.examId);
        resultList.add(
          Row(
            children: <Widget>[Text(_examString(examen)), _timeRow(i)],
          ),
        );
      } else if (i.title != null) {
        resultList.add(
          Row(
            children: <Widget>[Text(i.title), _timeRow(i)],
          ),
        );
      } else {
        resultList.add(Text('ERROR'));
      }
      resultList.add(Divider(
        thickness: ScreenUtil().setSp(1),
      ));
    }
    return resultList;
  }

  Widget _timeRow(EventItem eventItem) {
    if (_sameDayAndNotAllDay(
        parser.parse(eventItem.inici), parser.parse(eventItem.fi))) {
      DateFormat formatHour = DateFormat.Hm();
      String duration = formatHour.format((parser.parse(eventItem.inici))) +
          '-' +
          formatHour.format((parser.parse(eventItem.fi)));
      return Row(
        children: <Widget>[
          SizedBox(
            width: ScreenUtil().setWidth(10),
          ),
          IconTheme(
            data:
                IconThemeData(color: Colors.grey, size: ScreenUtil().setSp(15)),
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

  bool _sameDayAndNotAllDay(DateTime a, DateTime b) {
    int diffSec = a.difference(b).inSeconds;
    if (diffSec == 0 && a.hour == 0 && a.minute == 0 && a.second == 0) {
      return false;
    }
    int diffDay = a.difference(b).inDays;
    return (diffDay == 0 && a.day == b.day);
  }

  Map<String, List<EventItem>> _mapEventItemList(
      List<EventItem> eventItemList) {
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
    DateTime now = DateTime.now();
    String exactDayNow = dateFormat.format(now);
    DateTime exactTimeInDayNow = dateFormat.parse(exactDayNow);

    List<EventItem> resultList = new List();
    for (Event e in Dme().events.results) {
      DateTime fiTime = parser.parse(e.fi);
      if (fiTime.isAfter(DateTime.now()) &&
          (e.nom == 'FESTIU' ||
              e.nom == 'VACANCES' ||
              e.nom == 'FESTA FIB' ||
              e.nom == 'CANVI DIA')) {
        DateTime iniTime = parser.parse(e.inici);
        int difference = fiTime.difference(iniTime).inDays;
        for (int i = 0; i <= difference; i++) {
          DateTime iniciTime = iniTime.add(Duration(days: i));
          String exactDay = dateFormat.format(iniciTime);
          DateTime exactTimeInDay = dateFormat.parse(exactDay);
          if (exactTimeInDay
              .add(Duration(days: 1))
              .isAfter(exactTimeInDayNow)) {
            resultList.add(
                EventItem(e.nom, e.inici, e.fi, dateFormat.format(iniciTime)));
          }
        }
      }
    }

    for (Examen exam in Dme().examens.results) {
      for (Assignatura a in Dme().assignatures.results) {
        if (exam.assig == a.sigles) {
          DateTime eTime = parser.parse(exam.inici);
          DateTime fiTime = parser.parse(exam.fi);
          if (fiTime.isAfter(DateTime.now())) {
            int difference = fiTime.difference(eTime).inDays;
            for (int i = 0; i <= difference; i++) {
              DateTime iniciTime = eTime.add(Duration(days: i));
              String exactDay = dateFormat.format(iniciTime);
              DateTime exactTimeInDay = dateFormat.parse(exactDay);

              if (exactTimeInDay
                  .add(Duration(days: 1))
                  .isAfter(exactTimeInDayNow)) {
                resultList.add(EventItem.exam(exam.id, exam.inici, exam.fi,
                    dateFormat.format(iniciTime)));
              }
            }
          }
        }
      }
    }

    for (CustomEvent ce in Dme().customEvents.results) {
      DateTime eTime = parser.parse(ce.inici);
      DateTime fiTime = parser.parse(ce.fi);
      if (fiTime.isAfter(DateTime.now())) {
        int difference = fiTime.difference(eTime).inDays;
        if (fiTime.hour < eTime.hour) {
          difference++;
        } else if (fiTime.hour == eTime.hour && fiTime.minute < eTime.minute) {
          difference++;
        }
        for (int i = 0; i <= difference; i++) {
          DateTime iniciTime = eTime.add(Duration(days: i));
          String exactDay = dateFormat.format(iniciTime);
          DateTime exactTimeInDay = dateFormat.parse(exactDay);
          if (exactTimeInDay
              .add(Duration(days: 1))
              .isAfter(exactTimeInDayNow)) {
            resultList.add(EventItem.custom(ce.title, ce.description, ce.inici,
                ce.fi, dateFormat.format(iniciTime), ce.id));
          }
        }
      }
    }

    resultList.sort((a, b) {
      DateTime ta = dateFormat.parse(a.data);
      DateTime tb = dateFormat.parse(b.data);
      return ta.compareTo(tb);
    });

    return resultList;
  }

  String _examString(Examen examen) {
    String examString = '[' + examen.pla + '-' + examen.assig + '] ';
    if (examen.tipus == 'F') {
      examString += allTranslations.text('final_exam');
    } else {
      examString += allTranslations.text('midterm_exam');
    }
    if (examen.eslaboratori == 'S') {
      examString += ' (Lab)';
    }
    return examString;
  }
}

class EventItem {
  int examId;
  String title;
  String description;
  String data;
  String inici;
  bool isCustom = false;
  String customId;
  String fi;

  EventItem(this.title, this.inici, this.fi, this.data);
  EventItem.exam(this.examId, this.inici, this.fi, this.data);
  EventItem.custom(this.title, this.description, this.inici, this.fi, this.data,
      this.customId)
      : this.isCustom = true;
}

class CustomDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CustomDialogState();
  }
}

class CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
