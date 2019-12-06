import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:raco/src/ui/routes/drawer_menu/subject_view.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Subjects extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SubjectsState();
  }
}

class SubjectsState extends State<Subjects>
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
    /*
    return new Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text('subjects')),
        ),
        body: Container(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: BezierCircleHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: _subjectList(),
          ),
        ));

     */
    return new Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text('subjects')),
        ),
        body: Container(
          child: _subjectList()
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
              color: Color(codi),
              child: InkWell(
                onTap: () => _subjectTapped(n),
                child: Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  child: Column(
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
                        n.sigles +
                            ' - ' +
                            allTranslations.text('group') +
                            ': ' +
                            _group(n) +
                            ' - ' +
                            allTranslations.text('credits') +
                            ': ' +
                            _credits(n),
                        overflow: TextOverflow.visible,
                      )
                    ],
                  ),
                ),
              ));
        }).toList(),
      );
    }
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
        context,
        MaterialPageRoute(
            builder: (context) => SubjectView(
                  assignatura: a,
                  assignaturaGuia: Dme().assigGuia[a.id],
                  assignaturaURL: Dme().assigURL[a.id],
                )));
  }

  void _onRefresh() async {
    //update subjects info
    String accessToken = await user.getAccessToken();
    String lang = await user.getPreferredLanguage();
    RacoRepository rr = new RacoRepository(
        racoApiClient: RacoApiClient(
            httpClient: http.Client(), accessToken: accessToken, lang: lang));
    Assignatures assignatures = await rr.getAssignatures();
    Dme dme = Dme();
    dme.assignatures = assignatures;
    _assignColor(assignatures);
    await ReadWriteFile()
        .writeStringToFile(FileNames.ASSIGNATURES, jsonEncode(assignatures));
    dme.assigURL = new HashMap();
    dme.assigGuia = new HashMap();
    for (Assignatura a in assignatures.results) {
      AssignaturaURL assigURL = await rr.getAssignaturaURL(a);
      await ReadWriteFile()
          .writeStringToFile(FileNames.ASSIGNATURA_URL, jsonEncode(assigURL));
      dme.assigURL[a.id] = assigURL;
      AssignaturaGuia assigGuia = await rr.getAssignaturaGuia(a);
      await ReadWriteFile()
          .writeStringToFile(FileNames.ASSIGNATURA_GUIA, jsonEncode(assigGuia));
      dme.assigGuia[a.id] = assigGuia;
    }
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _assignColor(Assignatures assignatures) async {
    List<int> generatedHues = List();
    Random rand = Random();
    Dme().assigColors = new HashMap();
    int minimumSeparation = (360 / (assignatures.count * 4)).round();
    for (Assignatura a in assignatures.results) {
      int genHue = rand.nextInt(361);
      while (!_isValidColor(genHue, minimumSeparation, generatedHues)) {
        genHue = rand.nextInt(361);
      }
      generatedHues.add(genHue);

      HSVColor hsvcolor = HSVColor.fromAHSV(1, genHue.toDouble(), 0.5, 0.75);
      Color c = hsvcolor.toColor();
      Dme().assigColors[a.id] = c.value.toString();
      await user.writeToPreferences(a.id, c.value.toString());
    }
  }

  bool _isValidColor(int v, int separation, List<int> generatedHues) {
    for (int i in generatedHues) {
      int diff = v - i;
      if (diff < 0) {
        diff = diff * -1;
      }
      if (diff < separation) {
        return false;
      }
    }
    return true;
  }
}
