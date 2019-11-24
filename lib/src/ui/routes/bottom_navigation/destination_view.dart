import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raco/src/blocs/drawer_menu/drawer_bloc.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/ui/routes/bottom_navigation/destination.dart';
import 'package:raco/src/ui/routes/bottom_navigation/events_view.dart';
import 'package:raco/src/ui/routes/bottom_navigation/schedule.dart';
import 'package:raco/src/ui/routes/drawer_menu/drawer_menu.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'news.dart';
import 'notices.dart';
import 'package:intl/intl.dart';
import 'package:raco/flutter_datetime_picker-1.2.8-with-ca/flutter_datetime_picker.dart';

class DestinationView extends StatefulWidget {
  const DestinationView({Key key, this.destination}) : super(key: key);

  final Destination destination;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _startDateController;
  TextEditingController _endDateController;
  DateFormat formatter;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    formatter = DateFormat.yMd(allTranslations.currentLanguage).add_Hm();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _startDateController = TextEditingController();
    _startDateController.text = formatter.format(DateTime.now());
    _endDateController = TextEditingController();
    _endDateController.text = formatter.format(DateTime.now());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _translationBloc = BlocProvider.of<DrawerMenuBloc>(context);

    _onDrawerIconPressed() {
      _translationBloc.dispatch(DrawerIconPressedEvent());
    }

    return Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: Icon(Icons.home),
          onPressed: () => _onDrawerIconPressed(),
        ),
        title: Text(allTranslations.text('home')),
        backgroundColor: widget.destination.color,
        centerTitle: true,
      ),
      backgroundColor: widget.destination.color[100],
      body: _buildBody(),
      floatingActionButton: _addEventButton(),
    );
  }

  Widget _addEventButton() {
    if (widget.destination.index == 2) {
      return FloatingActionButton(
        onPressed: () => _buttonPressed(),
        child: IconTheme(
          data: IconThemeData(color: Colors.white),
          child: Icon(Icons.add),
        ),
      );
    }
    return null;
  }

  void _buttonPressed() {
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
                                      onSaved: (String val) {
                                        print('SSSSSSAAAAAAAAAAve:' + val);
                                      },
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
                                      onSaved: (String val) {
                                        print('SSSSSSAAAAAAAAAAve:' + val);
                                      },
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
                                  Dme().customEvents.count *= 1;
                                  DateTime ini = formatter
                                      .parse(_startDateController.text);
                                  DateTime fiT =
                                      formatter.parse(_endDateController.text);
                                  DateFormat customFormat =
                                      DateFormat('yyyy-M-dTH:m:s');
                                  Dme().customEvents.results.add(CustomEvent(
                                      _titleController.text,
                                      _descriptionController.text,
                                      customFormat.format(ini),
                                      customFormat.format(fiT)));
                                  await ReadWriteFile().writeStringToFile(
                                      FileNames.CUSTOM_EVENTS, jsonEncode(Dme().customEvents));
                                  setState(() {

                                  });
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
      if (date.isAfter(formatter.parse(_endDateController.text))) {
        _endDateController.text = formatter.format(date);
      }
      _startDateController.text = formatter.format(date);
    }, onConfirm: (date) {
      if (date.isAfter(formatter.parse(_endDateController.text))) {
        _endDateController.text = formatter.format(date);
      }
      _startDateController.text = formatter.format(date);
    },
        currentTime: formatter
            .parse(_startDateController.text)
            .add(Duration(minutes: 1)),
        locale: LocaleType.ca);
  }

  void _selectEndDate() async {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(Duration(days: 730)), onChanged: (date) {
      if (date.isBefore(formatter.parse(_startDateController.text))) {
        _startDateController.text = formatter.format(date);
      }
      _endDateController.text = formatter.format(date);
    }, onConfirm: (date) {
      if (date.isBefore(formatter.parse(_startDateController.text))) {
        _startDateController.text = formatter.format(date);
      }
      _endDateController.text = formatter.format(date);
    },
        currentTime:
            formatter.parse(_endDateController.text).add(Duration(minutes: 1)),
        locale: LocaleType.ca);
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    if (widget.destination.index == 0) {
      //schedule
      return Schedule();
    } else if (widget.destination.index == 1) {
      //notes
      return Notices();
    } else if (widget.destination.index == 2) {
      //events
      return EventsView();
    } else if (widget.destination.index == 3) {
      //news
      return News();
    } else {
      return null;
    }
  }
}
