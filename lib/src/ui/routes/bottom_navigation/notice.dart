import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/models.dart';
import 'package:intl/intl.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Notice extends StatelessWidget {
  final Avis avis;

  Notice({Key key, @required this.avis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    if (Dme().assigURL[avis.codiAssig] != null &&
        Dme().assigURL[avis.codiAssig].nom != null &&
        Dme().assigURL[avis.codiAssig].nom != ' ') {
      appBarTitle = Dme().assigURL[avis.codiAssig].nom;
    } else {
      appBarTitle = avis.codiAssig;
    }

    DateFormat format = DateFormat('yyyy-M-dTH:m:s');
    var formatter = new DateFormat.yMMMMd(allTranslations.currentLanguage);
    DateTime ta = format.parse(avis.dataModificacio);
    String time = formatter.format(ta);

    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: Container(
            color: Colors.grey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Text(avis.titol),
                    subtitle: Text(time),
                  ),
                ),
                Expanded(
                    child: Card(
                        child: Container(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    children: <Widget>[
                      Html(
                        data: avis.text,
                      )
                    ],
                  ),
                )))
              ],
            )));
  }

  _onLinkTap(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
