import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meta/meta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:raco/flutter_datetime_picker-1.2.8-with-ca/flutter_datetime_picker.dart';
import 'package:raco/src/blocs/grades/grades.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/models/custom_grades.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/repositories.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:intl/intl.dart';
import 'package:raco/src/repositories/user_repository.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class GradeRoute extends StatefulWidget {
  Assignatura assignatura;

  GradeRoute({Key key, @required this.assignatura}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GradeRouteState();
  }
}

class GradeRouteState extends State<GradeRoute>
    with SingleTickerProviderStateMixin {
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _markController;
  TextEditingController _percentageController;
  TextEditingController _startDateController;
  DateFormat _formatter;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _formatter = DateFormat.yMd(allTranslations.currentLanguage);
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _markController = TextEditingController();
    _percentageController = TextEditingController();
    _startDateController = TextEditingController();
    _startDateController.text = _formatter.format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _gradesBloc = BlocProvider.of<GradesBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_subjectString(widget.assignatura)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _buttonPressed(_gradesBloc),
        child: IconTheme(
          data: IconThemeData(color: Colors.white),
          child: Icon(Icons.add),
        ),
      ),
      body: BlocBuilder<GradesBloc, GradesState>(
        builder: (context, state) {
          if (state is GradeDeletedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
            WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
            _gradesBloc.dispatch(GradesInitEvent());
          } else if ( state is GradeEditedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
            _gradesBloc.dispatch(GradesInitEvent());
          }
         return Container(child: ListView(children: _listViewBody(_gradesBloc,context)));

        },
      ),

    );
  }

  List<Widget> _listViewBody(var _gradeBloc,BuildContext context) {
    int codi = int.parse(Dme().assigColors[widget.assignatura.sigles]);
    List<Widget> result = new List();
    result.add(SizedBox(
      height: ScreenUtil().setHeight(30),
    ));
    result.add(CircularPercentIndicator(
      radius: ScreenUtil().setWidth(140),
      lineWidth: ScreenUtil().setWidth(10),
      animation: true,
      percent: _subjectTotalGrade(widget.assignatura),
      center: new Text(
        (_subjectTotalGrade(widget.assignatura) * 10).toStringAsFixed(2),
        style: new TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Color(codi),
    ));
    List<CustomGrade> grades = Dme().customGrades.results.where((g) {
      return g.subjectId == widget.assignatura.sigles;
    }).toList();
    for (CustomGrade g in grades) {
      result.add(
        Card(
            child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        content: Container(
                            height: MediaQuery.of(context).size.height / 1.5,
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        g.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    _simplePopup(_gradeBloc ,g, setState)
                                  ],
                                ),
                                Divider(
                                  thickness: ScreenUtil().setSp(2),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      allTranslations.text('grade') + ': ',
                                      overflow: TextOverflow.visible,
                                    ),
                                    Text(
                                      g.grade.toStringAsFixed(2),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      allTranslations.text('percentage') + ': ',
                                      overflow: TextOverflow.visible,
                                    ),
                                    Text(
                                      (g.percentage * 100).toStringAsFixed(2) + '%',
                                      overflow: TextOverflow.visible,
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      allTranslations.text('date') + ': ',
                                      overflow: TextOverflow.visible,
                                    ),
                                    Text(
                                      g.data.toString(),
                                      overflow: TextOverflow.visible,
                                    )
                                  ],
                                ),
                                Divider(),
                                Expanded(
                                  child: ListView(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            g.comments,
                                            overflow: TextOverflow.visible,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )),
                      );
                    },
                  );
                });
          },
          child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        g.name,
                        overflow: TextOverflow.visible,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(g.data)
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Text(
                        allTranslations.text('grade') + ': ',
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        g.grade.toStringAsFixed(2),
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                      ),
                      Text(
                        allTranslations.text('percentage') + ': ',
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        (g.percentage * 100).toStringAsFixed(2) + '%',
                        overflow: TextOverflow.visible,
                      )
                    ],
                  ),
                ],
              )),
        )),
      );
    }
    return result;
  }

  Widget _simplePopup(var _gradeBloc,CustomGrade g, StateSetter po) => PopupMenuButton<int>(
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
            if (Platform.isIOS) {
              showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return new CupertinoAlertDialog(
                      title: new Text(allTranslations.text('delete')),
                      content: new Text(
                          allTranslations.text('grade_delete_confirmation')),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          child: Text(allTranslations.text('cancel')),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(allTranslations.text('accept')),
                          onPressed: () async {
                            _gradeBloc.dispatch(GradesDeleteEvent(customGrade: g));
                          },
                        )
                      ],
                    );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return new AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      title: new Text(allTranslations.text('delete')),
                      content: new Text(
                          allTranslations.text('grade_delete_confirmation')),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(allTranslations.text('cancel')),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text(allTranslations.text('accept')),
                          onPressed: () async {
                            _gradeBloc.dispatch(GradesDeleteEvent(customGrade: g));
                          },
                        ),
                      ],
                    );
                  });
            }

          } else if (value == 1) {
            _editButtonPressed(_gradeBloc,g, po);
          }
        },
      );

  void _editButtonPressed(var _gradeBloc ,CustomGrade g, StateSetter po) {
    _titleController.text = g.name;
    _descriptionController.text = g.comments;
    _startDateController.text = g.data;
    _percentageController.text = (g.percentage * 100).toStringAsFixed(2);
    _markController.text = g.grade.toStringAsFixed(2);
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
                                SizedBox(
                                  height: ScreenUtil().setHeight(5),
                                ),
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
                                    labelText:
                                        allTranslations.text('description'),
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
                                        labelText: allTranslations.text('date'),
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
                                new TextFormField(
                                  controller: _markController,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return allTranslations
                                          .text('empty_field_error');
                                    }
                                    if (!_isNumeric(value)) {
                                      return allTranslations
                                          .text('incorrect_value');
                                    }
                                    double v = double.tryParse(value);
                                    if (v < 0 || v > 10) {
                                      return allTranslations
                                          .text('incorrect_value');
                                    }
                                    return null;
                                  },
                                  decoration: new InputDecoration(
                                    labelText: allTranslations.text('grade'),
                                    fillColor: Colors.white,
                                    helperText:
                                        allTranslations.text('grade_help_text'),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                                new TextFormField(
                                  controller: _percentageController,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return allTranslations
                                          .text('empty_field_error');
                                    }
                                    if (!_isNumeric(value)) {
                                      return allTranslations
                                          .text('incorrect_value');
                                    }
                                    double v = double.tryParse(value);
                                    if (v < 0 || v > 100) {
                                      return allTranslations
                                          .text('incorrect_value');
                                    }
                                    List<CustomGrade> e =
                                        Dme().customGrades.results.where((gr) {
                                      return gr.subjectId ==
                                          widget.assignatura.sigles && g.id != gr.id;
                                    }).toList();
                                    double ac = v;
                                    for (CustomGrade c in e) {
                                      ac += c.percentage * 100;
                                    }
                                    if (ac > 100) {
                                      return allTranslations
                                          .text('percentage_error');
                                    }
                                    return null;
                                  },
                                  decoration: new InputDecoration(
                                    labelText:
                                        allTranslations.text('percentage'),
                                    fillColor: Colors.white,
                                    suffix: Text('%'),
                                    helperText: allTranslations
                                        .text('percentage_help_text'),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  keyboardType:  TextInputType.numberWithOptions(decimal: true),
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
                                  CustomGrade aux = Dme()
                                      .customGrades
                                      .results
                                      .firstWhere((gr) {
                                    return gr.id == g.id;
                                  });
                                  aux.percentage = double.tryParse(
                                          _percentageController.text) /
                                      100;
                                  aux.name = _titleController.text;
                                  aux.data = _startDateController.text;

                                  aux.grade =
                                      double.tryParse(_markController.text);
                                  aux.comments = _descriptionController.text;

                                  _gradeBloc.dispatch(GradesEditEvent());
                                  _titleController.clear();
                                  _descriptionController.clear();
                                  _percentageController.clear();
                                  _markController.clear();
                                  //setState(() {});
                                  po(() {});
                                }
                              })
                        ])
                  ],
                )),
          );
        });
  }

  double _subjectTotalGrade(Assignatura a) {
    CustomGrades g = Dme().customGrades;
    List<CustomGrade> lista = g.results.where((gr) {
      return gr.subjectId == a.sigles;
    }).toList();
    double p = 0.0;
    for (CustomGrade c in lista) {
      p += c.grade * (c.percentage / 10);
    }

    return p;
  }

  String _nExams(Assignatura a) {
    CustomGrades g = Dme().customGrades;
    List<CustomGrade> lista = g.results.where((gr) {
      return gr.subjectId == a.sigles;
    }).toList();
    return lista.length.toString();
  }

  String _subjectString(Assignatura a) {
    if (a.nom == ' ' || a.nom == null) {
      return a.sigles;
    }
    return a.nom;
  }

  void _buttonPressed(var _gradesBloc) {
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
                                SizedBox(
                                  height: ScreenUtil().setHeight(5),
                                ),
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
                                    labelText:
                                        allTranslations.text('description'),
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
                                        labelText: allTranslations.text('date'),
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
                                new TextFormField(
                                  controller: _markController,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return allTranslations
                                          .text('empty_field_error');
                                    }
                                    if (!_isNumeric(value)) {
                                      return allTranslations
                                          .text('incorrect_value');
                                    }
                                    double v = double.tryParse(value);
                                    if (v < 0 || v > 10) {
                                      return allTranslations
                                          .text('incorrect_value');
                                    }
                                    return null;
                                  },
                                  decoration: new InputDecoration(
                                    labelText: allTranslations.text('grade'),
                                    fillColor: Colors.white,
                                    helperText:
                                        allTranslations.text('grade_help_text'),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  keyboardType:  TextInputType.numberWithOptions(decimal: true),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                                new TextFormField(
                                  controller: _percentageController,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return allTranslations
                                          .text('empty_field_error');
                                    }
                                    if (!_isNumeric(value)) {
                                      return allTranslations
                                          .text('incorrect_value');
                                    }
                                    double v = double.tryParse(value);
                                    if (v < 0 || v > 100) {
                                      return allTranslations
                                          .text('incorrect_value');
                                    }
                                    List<CustomGrade> e =
                                        Dme().customGrades.results.where((g) {
                                      return g.subjectId ==
                                          widget.assignatura.sigles;
                                    }).toList();
                                    double ac = v;
                                    for (CustomGrade c in e) {
                                      ac += c.percentage * 100;
                                    }

                                    if (ac > 100) {
                                      return allTranslations
                                          .text('percentage_error');
                                    }
                                    return null;
                                  },
                                  decoration: new InputDecoration(
                                    labelText:
                                        allTranslations.text('percentage'),
                                    fillColor: Colors.white,
                                    suffix: Text('%'),
                                    helperText: allTranslations
                                        .text('percentage_help_text'),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  keyboardType:  TextInputType.numberWithOptions(decimal: true),
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
                                  CustomGrade customGrade = CustomGrade(
                                      DateTime.now().toIso8601String(),
                                      widget.assignatura.sigles,
                                      _titleController.text,
                                      _descriptionController.text,
                                      _startDateController.text,
                                      double.tryParse(_markController.text),
                                      double.tryParse(
                                          _percentageController.text) /
                                          100);

                                  _gradesBloc.dispatch(GradesAddEvent(customGrade: customGrade));

                                  _titleController.clear();
                                  _descriptionController.clear();
                                  _percentageController.clear();
                                  _markController.clear();
                                  _startDateController.text =
                                      _formatter.format(DateTime.now());
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
    LocaleType l;
    if (allTranslations.currentLanguage == 'ca') {
      l = LocaleType.ca;
    } else if (allTranslations.currentLanguage == 'es') {
      l = LocaleType.es;
    } else {
      l = LocaleType.en;
    }
    DatePicker.showDatePicker(context, showTitleActions: true,
        onConfirm: (date) {
      _startDateController.text = _formatter.format(date);
    },
        currentTime: _formatter
            .parse(_startDateController.text)
            .add(Duration(minutes: 1)),
        locale: l);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _markController.dispose();
    _percentageController.dispose();
    super.dispose();
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }
}
