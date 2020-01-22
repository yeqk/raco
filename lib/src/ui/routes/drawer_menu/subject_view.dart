import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:raco/flutter_datetime_picker-1.2.8-with-ca/src/date_format.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/models.dart';
import 'package:intl/intl.dart';
import 'package:raco/src/models/requisits.dart';
import 'package:raco/src/repositories/repositories.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/repositories/user_repository.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:share_extend/share_extend.dart';

class SubjectView extends StatefulWidget {
  final Assignatura assignatura;
  final AssignaturaGuia assignaturaGuia;
  final AssignaturaURL assignaturaURL;

  SubjectView(
      {Key key,
      @required this.assignatura,
      @required this.assignaturaGuia,
      @required this.assignaturaURL})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SubjectViewState();
  }
}

class MyItem {
  MyItem({this.isExpanded: false, this.header, this.body});

  bool isExpanded;
  final String header;
  final Widget body;
}

class SubjectViewState extends State<SubjectView> {
  List<MyItem> _items = List();
  double itemTitle = 18;

  @override
  void initState() {
    super.initState();
    if (Dme().assigGuia.containsKey(widget.assignatura.sigles) &&
        widget.assignatura.guia != null) {
      _fillItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    if (widget.assignatura.nom != null && widget.assignatura.nom != ' ') {
      appBarTitle = widget.assignatura.nom;
    } else {
      appBarTitle = widget.assignatura.sigles;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: _body(),
    );
  }

  void _fillItems() {
    _items.clear();
    _items.add(MyItem(
        header: allTranslations.text('general'),
        body: _basicItem(),
        isExpanded: true));
    _items.add(MyItem(
        header: allTranslations.text('teachers'), body: _teachersItem()));
    _items.add(MyItem(
        header: allTranslations.text('weekly_hours'), body: _weekHoursItem()));
    /*
    _items
        .add(MyItem(header: allTranslations.text('competences'), body: _competencesItem()));

     */
    _items.add(MyItem(
        header: allTranslations.text('contents'), body: _contentsItem()));
    _items.add(MyItem(
        header: allTranslations.text('activities'), body: _activitiesItem()));
    _items.add(MyItem(
        header: allTranslations.text('teaching_methodology'),
        body: _teachingMethodologyItem()));
    _items.add(MyItem(
        header: allTranslations.text('evaluation_methodology'),
        body: _evaluationMethodologyItem()));
    _items.add(MyItem(
        header: allTranslations.text('bibliography'),
        body: _bibliographyItem()));
    _items.add(MyItem(
        header: allTranslations.text('previous_capacities'),
        body: _previousCapacitiesItem()));
  }

  Widget _basicItem() {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
      child: Card(
          color: Color(0xffd9edf7),
          child: Container(
            margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(100),
                      child: Text(
                        allTranslations.text('credits'),
                        overflow: TextOverflow.visible,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(widget.assignatura.credits.toString(),
                        overflow: TextOverflow.visible)
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(100),
                      child: Text(allTranslations.text('types'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Text(_subjType(), overflow: TextOverflow.visible),
                    )
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(100),
                      child: Text(allTranslations.text('requirements'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.visible),
                    ),
                    _requirements()
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(100),
                      child: Text(allTranslations.text('department'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text(widget.assignaturaGuia.departament,
                        overflow: TextOverflow.visible)
                  ],
                ),
                (widget.assignaturaGuia.web != '') ? Divider() : SizedBox(),
                (widget.assignaturaGuia.web != '')
                    ? Row(
                        children: <Widget>[
                          Container(
                            width: ScreenUtil().setWidth(100),
                            child: Text(allTranslations.text('web'),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Text(widget.assignaturaGuia.web,
                              overflow: TextOverflow.visible)
                        ],
                      )
                    : SizedBox(),
                (widget.assignaturaGuia.mail != '') ? Divider() : SizedBox(),
                (widget.assignaturaGuia.mail != '')
                    ? Row(
                        children: <Widget>[
                          Container(
                              width: ScreenUtil().setWidth(100),
                              child: Text(allTranslations.text('mail'),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Text(widget.assignaturaGuia.mail,
                              overflow: TextOverflow.visible)
                        ],
                      )
                    : SizedBox()
              ],
            ),
          )),
    );
  }

  String _subjType() {
    if (widget.assignaturaURL.obligatorietats.first.nomEspecialitat == '') {
      return allTranslations
          .text(widget.assignaturaURL.obligatorietats.first.codiOblig);
    } else {
      return allTranslations
              .text(widget.assignaturaURL.obligatorietats.first.codiOblig) +
          ' (' +
          widget.assignaturaURL.obligatorietats.first.nomEspecialitat +
          ')';
    }
  }

  Widget _requirements() {
    List<Requisit> requirements = List();
    Dme().requisits.results.forEach((r) {
      if (r.destination == widget.assignatura.sigles) {
        requirements.add(r);
      }
    });
    if (requirements.length == 0) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(allTranslations.text('no_requirements'),
                  overflow: TextOverflow.visible),
            ],
          )
        ],
      );
    }
    return Column(
      children: requirements.map((r) {
        return Row(
          children: <Widget>[
            Text(allTranslations.text(r.tipus) + ': ' + r.origin,
                overflow: TextOverflow.visible),
          ],
        );
      }).toList(),
    );
  }

  Widget _teachersItem() {
    return Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
        child: FittedBox(
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[_teacherInCharge(), _othersTeachers()],
              ),
            ],
          ),
        ));
  }

  Widget _teacherInCharge() {
    List<Professor> profs = widget.assignaturaGuia.professors.where((t) {
      return t.isResponsable;
    }).toList();
    if (profs.length > 0) {
      List<Widget> lines = List();
      lines.add(Text(allTranslations.text('person_in_charge'),
          style: TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.visible));
      profs.forEach((p) {
        String htmlListItem = '<ul><li>' +
            p.nom +
            ' (' +
            '<a href=\"mailto:' +
            p.email +
            '\">' +
            p.email +
            '</a>)</li></ul>';
        lines
            .add(Html(data: htmlListItem, onLinkTap: (url) => _onMailTap(url)));
      });
      return FittedBox(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: lines),
      );
    }
    return SizedBox();
  }

  void _onMailTap(String mail) async {
    if (await canLaunch(mail)) {
      await launch(mail);
    } else {
      throw 'Could not launch $mail';
    }
  }

  Widget _othersTeachers() {
    List<Professor> profs = widget.assignaturaGuia.professors.where((t) {
      return !t.isResponsable;
    }).toList();
    if (profs.length > 0) {
      List<Widget> lines = List();
      lines.add(Text(allTranslations.text('others'),
          style: TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.visible));
      profs.forEach((p) {
        String htmlListItem = '<ul><li>' +
            p.nom +
            ' (' +
            '<a href=\"mailto:' +
            p.email +
            '\">' +
            p.email +
            '</a>)</li></ul>';
        lines
            .add(Html(data: htmlListItem, onLinkTap: (url) => _onMailTap(url)));
      });
      return FittedBox(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: lines),
      );
    }
    return SizedBox();
  }

  Widget _weekHoursItem() {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
      child: Card(
          color: Color(0xffeff6f9),
          child: Container(
            margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: Text(
                        allTranslations.text('theory'),
                        overflow: TextOverflow.visible,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(widget.assignaturaGuia.hores.teoria.toString(),
                        overflow: TextOverflow.visible)
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(3),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: Text(allTranslations.text('problems'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Text(
                          widget.assignaturaGuia.hores.problemes.toString(),
                          overflow: TextOverflow.visible),
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(3),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: Text(allTranslations.text('laboratory'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Text(
                        widget.assignaturaGuia.hores.teoria.toString(),
                        overflow: TextOverflow.visible,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(3),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: Text(allTranslations.text('guided_learning'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text(
                        widget.assignaturaGuia.hores.aprenentatgeDirigit
                            .toString(),
                        overflow: TextOverflow.visible)
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(3),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(200),
                      child: Text(allTranslations.text('autonomous_learning'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text(
                        widget.assignaturaGuia.hores.aprenentatgeAutonom
                            .toString(),
                        overflow: TextOverflow.visible)
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget _contentsItem() {
    List<Contingut> contingut = widget.assignaturaGuia.continguts;
    if (contingut.length > 0) {
      List<Widget> lines = List();
      contingut.forEach((c) {
        lines.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(c.nom,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.visible),
            Text(c.descripcio, overflow: TextOverflow.visible)
          ],
        ));
        lines.add(SizedBox(
          height: ScreenUtil().setHeight(10),
        ));
      });
      return Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: lines),
      );
    }
    return SizedBox();
  }

  Widget _activitiesItem() {
    List<int> ordre = widget.assignaturaGuia.ordreActivitats;
    List<Activitat> act = widget.assignaturaGuia.activitats;
    List<ActeAvaluatiu> actAv = widget.assignaturaGuia.actesAvaluatius;
    List<Widget> lines = List();
    lines.add(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
          decoration:
              BoxDecoration(border: Border.all(color: Color(0xff21c2f8))),
          child: Text(allTranslations.text('activity'),
              overflow: TextOverflow.visible),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(10),
        ),
        Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
          decoration:
              BoxDecoration(border: Border.all(color: Color(0xfff36e44))),
          child: Text(allTranslations.text('evaluation_act'),
              overflow: TextOverflow.visible),
        )
      ],
    ));
    ordre.forEach((o) {
      lines.add(SizedBox(
        height: ScreenUtil().setHeight(10),
      ));
      if (_isActivitat(o)) {
        Activitat activitat = act.where((a) {
          return a.id == o;
        }).first;
        lines.add(Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
          decoration:
              BoxDecoration(border: Border.all(color: Color(0xff21c2f8))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(activitat.nom,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.visible),
                  Expanded(
                    child: SizedBox(),
                  )
                ],
              ),
              Text(activitat.descripcio, overflow: TextOverflow.visible),
              Text(allTranslations.text('contents') + ':',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.visible),
              Html(
                data: _activityContentString(activitat.continguts),
              ),
              _horari(
                  activitat.teoria.hores,
                  activitat.problemes.hores,
                  activitat.laboratori.hores,
                  activitat.aprenentatgeDirigit.hores,
                  activitat.aprenentatgeAutonom.hores)
            ],
          ),
        ));
      } else {
        ActeAvaluatiu acteAvaluatiu = actAv.where((a) {
          return a.id == o;
        }).first;
        lines.add(Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
          decoration:
              BoxDecoration(border: Border.all(color: Color(0xfff36e44))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(acteAvaluatiu.nom,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.visible),
                  Expanded(
                    child: SizedBox(),
                  )
                ],
              ),
              Text(acteAvaluatiu.descripcio),
              Row(
                children: <Widget>[
                  Text(allTranslations.text('week') + ': ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.visible),
                  Text(acteAvaluatiu.setmana.toString()),
                  acteAvaluatiu.foraHoraris
                      ? Text(
                          ' (' +
                              allTranslations.text('outside_class_hours') +
                              ')',
                          overflow: TextOverflow.visible)
                      : SizedBox()
                ],
              ),
              Row(
                children: <Widget>[
                  Text(allTranslations.text('type') + ': ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.visible),
                  Text(allTranslations.text(acteAvaluatiu.tipus),
                      overflow: TextOverflow.visible)
                ],
              ),
              _horariExams(
                  acteAvaluatiu.horesDuracio, acteAvaluatiu.horesEstudi)
            ],
          ),
        ));
      }
    });
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: lines),
    );
  }

  Widget _horari(double t, double p, double l, double gl, double al) {
    return Card(
        color: Color(0xffeff6f9),
        child: Container(
          margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(200),
                    child: Text(
                      allTranslations.text('theory'),
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(t.toString() + 'h', overflow: TextOverflow.visible)
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(3),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(200),
                    child: Text(allTranslations.text('problems'),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Text(p.toString() + 'h',
                        overflow: TextOverflow.visible),
                  )
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(3),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(200),
                    child: Text(allTranslations.text('laboratory'),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Text(
                      l.toString() + 'h',
                      overflow: TextOverflow.visible,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(3),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(200),
                    child: Text(allTranslations.text('guided_learning'),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Text(gl.toString() + 'h', overflow: TextOverflow.visible)
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(3),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(200),
                    child: Text(allTranslations.text('autonomous_learning'),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Text(al.toString() + 'h', overflow: TextOverflow.visible)
                ],
              ),
            ],
          ),
        ));
  }

  Widget _horariExams(int duration, int dedication) {
    return Card(
        color: Color(0xffeff6f9),
        child: Container(
          margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(200),
                    child: Text(
                      allTranslations.text('duration'),
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(duration.toDouble().toString() + 'h',
                      overflow: TextOverflow.visible)
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(3),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(200),
                    child: Text(allTranslations.text('dedication'),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Text(dedication.toDouble().toString() + 'h',
                        overflow: TextOverflow.visible),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  bool _isActivitat(int id) {
    bool isActivitat = false;
    widget.assignaturaGuia.activitats.forEach((a) {
      if (a.id == id) {
        isActivitat = true;
      }
      ;
    });
    return isActivitat;
  }

  String _activityContentString(List<int> coningut) {
    String htmlString = '<ul>';
    List<Contingut> actList = widget.assignaturaGuia.continguts;
    for (int idAct in coningut) {
      Contingut a = actList.firstWhere((x) {
        return x.id == idAct;
      });
      htmlString += '<li>' + a.nom + '</li>';
    }
    htmlString += '</ul>';
    return htmlString;
  }

  Widget _teachingMethodologyItem() {
    return Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
        child: Column(
          children: <Widget>[
            Text(widget.assignaturaGuia.metodologiaDocent,
                overflow: TextOverflow.visible)
          ],
        ));
  }

  Widget _evaluationMethodologyItem() {
    return Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
        child: Column(
          children: <Widget>[Text(widget.assignaturaGuia.metodologiaAvaluacio)],
        ));
  }

  Widget _bibliographyItem() {
    return Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
        child: FittedBox(
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[_basicBiblio(), _complementaryBiblio()],
              ),
            ],
          ),
        ));
  }

  Widget _basicBiblio() {
    List<Biblio> biblio = widget.assignaturaGuia.bibliografia.basica;
    if (biblio.length > 0) {
      List<Widget> lines = List();
      lines.add(Text(allTranslations.text('basic') + ':',
          style: TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.visible));
      biblio.forEach((p) {
        String htmlListItem = '<ul><li>' +
            '<b>' +
            p.titol +
            '</b>' +
            ' - ' +
            p.autor +
            '.' +
            p.editorial +
            '.' +
            p.anyBib +
            '. ISBN: ' +
            p.isbn +
            ' ' +
            '<a href=\"' +
            p.url +
            '\">' +
            p.url +
            '</a>' +
            '</li></ul>';
        lines.add(SizedBox(
          height: ScreenUtil().setHeight(10),
        ));
        lines
            .add(Html(data: htmlListItem, onLinkTap: (url) => _onMailTap(url)));
      });
      return FittedBox(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: lines),
      );
    }
    return SizedBox();
  }

  Widget _complementaryBiblio() {
    List<Biblio> biblio = widget.assignaturaGuia.bibliografia.complementaria;
    if (biblio.length > 0) {
      List<Widget> lines = List();
      lines.add(Text(allTranslations.text('complementary') + ':',
          style: TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.visible));
      biblio.forEach((p) {
        String htmlListItem = '<ul><li>' +
            '<b>' +
            p.titol +
            '</b>' +
            ' - ' +
            p.autor +
            '.' +
            p.editorial +
            '.' +
            p.anyBib +
            '. ISBN: ' +
            p.isbn +
            ' ' +
            '<a href=\"' +
            p.url +
            '\">' +
            p.url +
            '</a>' +
            '</li></ul>';
        lines.add(SizedBox(
          height: ScreenUtil().setHeight(10),
        ));
        lines
            .add(Html(data: htmlListItem, onLinkTap: (url) => _onMailTap(url)));
      });
      return FittedBox(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: lines),
      );
    }
    return SizedBox();
  }

  Widget _previousCapacitiesItem() {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(widget.assignaturaGuia.capacitatsPrevies,
                  overflow: TextOverflow.visible),
            ],
          )
        ],
      ),
    );
  }

  Widget _body() {
    if (!Dme().assigGuia.containsKey(widget.assignatura.sigles) ||
        widget.assignatura.guia == null) {
      return ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(allTranslations.text('no_info'),
                    style: TextStyle(color: Colors.grey),
                    overflow: TextOverflow.visible)
              ],
            ),
          )
        ],
      );
    } else {
      return ListView(
        children: <Widget>[
          new ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _items[index].isExpanded = !_items[index].isExpanded;
              });
            },
            children: _items.map((MyItem item) {
              return new ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return new Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(item.header,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(itemTitle)),
                            overflow: TextOverflow.visible),
                      ),
                    );
                  },
                  isExpanded: item.isExpanded,
                  body: item.body);
            }).toList(),
          ),
        ],
      );
    }
  }
}
