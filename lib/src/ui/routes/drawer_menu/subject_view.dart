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
import 'package:raco/src/resources/user_repository.dart';
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
    if (Dme().assigGuia.containsKey(widget.assignatura.sigles) ||
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
    _items
        .add(MyItem(header: allTranslations.text('competences'), body: _competencesItem()));
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
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
      lines.add(Text(
        allTranslations.text('person_in_charge'),
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
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
      lines.add(Text(
        allTranslations.text('others'),
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
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
                Divider(),
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
                Divider(),
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
                Divider(),
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
                Divider(),
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

  Widget _competencesItem() {
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
                Divider(),
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
                Divider(),
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
                Divider(),
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
                Divider(),
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
                Text(
                  allTranslations.text('no_info'),
                  style: TextStyle(color: Colors.grey),
                )
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
                        child: Text(
                          item.header,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(itemTitle)),
                        ),
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
