import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meta/meta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/models/custom_grades.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/repositories.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:intl/intl.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/ui/routes/drawer_menu/grade_route.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class GradesRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GradesRouteState();
  }
}

class GradesRouteState extends State<GradesRoute>
    with SingleTickerProviderStateMixin {
  RefreshController _refreshController;

  @override
  void initState() {
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
    List<Assignatura> subjects = Dme().assignatures.results;
    return new Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text('grades')),
        ),
        body: Container(
          child:  _subjectList()
        ));
  }

  Widget _subjectList() {
    List<Assignatura> subjects = Dme().assignatures.results;
    if (subjects.length == 0) {
      return ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  allTranslations.text('no_subjects'),
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          )
        ],
      );
    } else {
      return ListView(
        children: subjects.map((Assignatura n) {
          int codi = int.parse(Dme().assigColors[n.sigles]);
          return Card(
              child: InkWell(
                onTap: () => _subjectTapped(n),
                child: Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _subjectString(n),
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.visible,
                          ),
                          Divider(),
                          Text(
                            _nExams(n) + ' '+allTranslations.text('registered'),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.visible,
                          )
                        ],
                      ),
                       CircularPercentIndicator(
                        radius: ScreenUtil().setWidth(90),
                        lineWidth: ScreenUtil().setWidth(10),
                        animation: true,
                        percent: _subjectTotalGrade(n),
                        center: new Text(
                          (_subjectTotalGrade(n)*10).toStringAsFixed(2),
                          style:
                          new TextStyle(fontSize: 20.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Color(codi),
                      )
                    ],
                  )
                ),
              ));
        }).toList(),
      );
    }
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

  String _group(Assignatura a) {
    if (a.grup == null) {
      return allTranslations.text('na');
    }
    return a.grup;
  }

  String _credits(Assignatura a) {
    if (a.credits == null) {
      return allTranslations.text('na');
    }
    return a.credits.toString();
  }

  void _subjectTapped(Assignatura a) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GradeRoute(assignatura: a,)));
  }

  void _onRefresh() async {
    //update subjects info
    print('updated');
    _refreshController.refreshCompleted();
  }
}
