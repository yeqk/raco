import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meta/meta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:raco/flutter_datetime_picker-1.2.8-with-ca/flutter_datetime_picker.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/models/custom_grades.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/repositories.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:intl/intl.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class GradeView extends StatefulWidget {
  Assignatura assignatura;

  GradeView({Key key, @required this.assignatura}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GradeViewState();
  }
}

class GradeViewState extends State<GradeView>
    with SingleTickerProviderStateMixin {
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _markController;
  TextEditingController _percentageController;
  DateFormat _formatter;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _formatter = DateFormat.yMd(allTranslations.currentLanguage).add_Hm();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _markController = TextEditingController();
    _percentageController = TextEditingController();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_subjectString(widget.assignatura)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _buttonPressed(),
        child: IconTheme(
          data: IconThemeData(color: Colors.white),
          child: Icon(Icons.add),
        ),
      ),
      body: Container(
        child: ListView(
          children: _listViewBody()
        )
      ),
    );
  }

  List<Widget> _listViewBody() {
    int codi = int.parse(Dme().assigColors[widget.assignatura.sigles]);
    List<Widget> result = new List();
    result.add(SizedBox(height: ScreenUtil().setHeight(30),));
    result.add(CircularPercentIndicator(
      radius: ScreenUtil().setWidth(140),
      lineWidth: ScreenUtil().setWidth(10),
      animation: true,
      percent: _subjectTotalGrade(widget.assignatura),
      center: new Text(
        (_subjectTotalGrade(widget.assignatura)*10).toString(),
        style:
        new TextStyle(fontSize: ScreenUtil().setSp(40)),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Color(codi),
    ));
    List<CustomGrade> grades = Dme().customGrades.results;
    for (CustomGrade g in grades) {
      result.add(Dismissible(
        key: Key(g.id),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Text(g.name, overflow: TextOverflow.visible,style: TextStyle(fontWeight: FontWeight.bold),),
                 Divider(),
                 Row(
                   children: <Widget>[Text(allTranslations.text('grade') + ': '),
                     Text(g.grade.toString(), overflow: TextOverflow.visible,),
                     SizedBox(width: ScreenUtil().setWidth(10),),
                     Text(allTranslations.text('percentage') + ': '),
                     Text(g.grade.toString() + '%', overflow: TextOverflow.visible,)],

                 ),
               ],
            )
          ),
        ),
      ));
    }
    return result;
  }

  double _subjectTotalGrade(Assignatura a) {
    CustomGrades g = Dme().customGrades;
    List<CustomGrade> lista = g.results.where((gr) {
      return gr.subjectId == a.sigles;
    }).toList();
    double p = 0.0;
    for (CustomGrade c in lista) {
      p += c.grade*(c.percentage/10);
    };
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
                                new TextFormField(
                                  controller: _markController,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return allTranslations
                                          .text('empty_field_error');
                                    }
                                    if (!_isNumeric(value)) {
                                      return allTranslations.text('incorrect_value');
                                    }
                                    double v = double.tryParse(value);
                                    if (v < 0 || v > 10) {
                                      return allTranslations.text('incorrect_value');
                                    }
                                    return null;
                                  },
                                  decoration: new InputDecoration(
                                    labelText: allTranslations.text('grade'),
                                    fillColor: Colors.white,
                                    helperText: allTranslations.text('grade_help_text'),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                      new BorderRadius.circular(20.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  keyboardType: TextInputType.number,
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
                                      return allTranslations.text('incorrect_value');
                                    }
                                    double v = double.tryParse(value);
                                    if (v < 0 || v > 100) {
                                      return allTranslations.text('incorrect_value');
                                    }
                                    return null;
                                  },
                                  decoration: new InputDecoration(
                                    labelText: allTranslations.text('percentage'),
                                    fillColor: Colors.white,
                                    suffix: Text('%'),
                                    helperText: allTranslations.text('percentage_help_text'),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                      new BorderRadius.circular(20.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  keyboardType: TextInputType.number,
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
                                  Dme().customGrades.count += 1;
                                  Dme().customGrades.results.add(CustomGrade(DateTime.now().toIso8601String(), widget.assignatura.sigles, _titleController.text, _descriptionController.text, double.tryParse(_markController.text), double.tryParse(_percentageController.text)/100));
                                  await ReadWriteFile().writeStringToFile(
                                      FileNames.CUSTOM_GRADES, jsonEncode(Dme().customGrades));
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _markController.dispose();
    _percentageController.dispose();
    super.dispose();
  }

  bool _isNumeric(String str) {
    if(str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }
}
