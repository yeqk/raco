import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raco/flutter_datetime_picker-1.2.8-with-ca/flutter_datetime_picker.dart' as prefix0;
import 'package:raco/src/blocs/drawer_menu/drawer_bloc.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/ui/routes/bottom_navigation/destination.dart';
import 'package:raco/src/ui/routes/bottom_navigation/schedule.dart';
import 'package:raco/src/ui/routes/drawer_menu/drawer_menu.dart';
import 'package:raco/src/utils/app_colors.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'events_route.dart';
import 'news_route.dart';
import 'package:intl/intl.dart';
import 'package:raco/flutter_datetime_picker-1.2.8-with-ca/flutter_datetime_picker.dart';

import 'notices_route.dart';

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
  DateFormat _formatter;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _formatter = DateFormat.yMd(allTranslations.currentLanguage).add_Hm();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _startDateController = TextEditingController();
    _startDateController.text = _formatter.format(DateTime.now());
    _endDateController = TextEditingController();
    _endDateController.text = _formatter.format(DateTime.now());

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
          icon: Icon(Icons.home,color: Colors.white,),
          onPressed: () => _onDrawerIconPressed(),
        ),
        title: Text(allTranslations.text('home'),style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: AppColors().primary,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
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
                                SizedBox(height: ScreenUtil().setHeight(5),),
                                new TextFormField(
                                  controller: _titleController,
                                  maxLines: 1,
                                  maxLength: 32,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return allTranslations
                                          .text('empty_field_error');
                                    }
                                    return null;
                                  },
                                  decoration: new InputDecoration(
                                    labelText: allTranslations.text('title'),
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
                                    labelText: allTranslations.text('description'),
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
                                  Dme().customEvents.count += 1;
                                  DateTime ini = _formatter
                                      .parse(_startDateController.text);
                                  DateTime fiT =
                                  _formatter.parse(_endDateController.text);
                                  DateFormat customFormat =
                                      DateFormat('yyyy-MM-ddTHH:mm:ss');
                                  Dme().customEvents.results.add(CustomEvent(DateTime.now().toIso8601String(),
                                      _titleController.text,
                                      _descriptionController.text,
                                      customFormat.format(ini),
                                      customFormat.format(fiT)));
                                  await ReadWriteFile().writeStringToFile(
                                      FileNames.CUSTOM_EVENTS, jsonEncode(Dme().customEvents));
                                  setState(() {

                                  });
                                  Navigator.of(context).pop();
                                  _titleController.clear();
                                  _descriptionController.clear();
                                  _startDateController.text = _formatter.format(DateTime.now());
                                  _endDateController.text = _formatter.format(DateTime.now());

                                }
                              })
                        ])
                  ],
                )),
          );
        });
  }

  void _selectStartDate() async {
    LocaleType l;
    if (allTranslations.currentLanguage == 'ca') {
      l = prefix0.LocaleType.ca;
    } else if (allTranslations.currentLanguage == 'es') {
      l = prefix0.LocaleType.es;
    } else {
      l = prefix0.LocaleType.en;
    }
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(Duration(days: 730)), onChanged: (date) {
      if (date.isAfter(_formatter.parse(_endDateController.text))) {
        _endDateController.text = _formatter.format(date);
      }
      _startDateController.text = _formatter.format(date);
    }, onConfirm: (date) {
      if (date.isAfter(_formatter.parse(_endDateController.text))) {
        _endDateController.text = _formatter.format(date);
      }
      _startDateController.text = _formatter.format(date);
    },
        currentTime: _formatter
            .parse(_startDateController.text)
            .add(Duration(minutes: 1)),
        locale: l);
  }

  void _selectEndDate() async {
    LocaleType l;
    if (allTranslations.currentLanguage == 'ca') {
      l = prefix0.LocaleType.ca;
    } else if (allTranslations.currentLanguage == 'es') {
      l = prefix0.LocaleType.es;
    } else {
      l = prefix0.LocaleType.en;
    }
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(Duration(days: 730)), onChanged: (date) {
      if (date.isBefore(_formatter.parse(_startDateController.text))) {
        _startDateController.text = _formatter.format(date);
      }
      _endDateController.text = _formatter.format(date);
    }, onConfirm: (date) {
      if (date.isBefore(_formatter.parse(_startDateController.text))) {
        _startDateController.text = _formatter.format(date);
      }
      _endDateController.text = _formatter.format(date);
    },
        currentTime:
        _formatter.parse(_endDateController.text).add(Duration(minutes: 1)),
        locale: l);
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    if (widget.destination.index == 0) {
      //schedule
      return Schedule();
    } else if (widget.destination.index == 1) {
      //notes
      return NoticesRoute();
    } else if (widget.destination.index == 2) {
      //events
      return EventsRoute();
    } else if (widget.destination.index == 3) {
      //news
      return NewsRoute();
    } else {
      return null;
    }
  }
}
