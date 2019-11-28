import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/models.dart';
import 'package:intl/intl.dart';
import 'package:raco/src/repositories/repositories.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:share_extend/share_extend.dart';

class SubjectView extends StatelessWidget {
  final Assignatura assignatura;

  SubjectView({Key key, @required this.assignatura}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    if (assignatura.nom != null && assignatura.nom != ' ') {
      appBarTitle = assignatura.nom;
    } else {
      appBarTitle = assignatura.sigles;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: _itemBody(),
    );
  }

  Widget _itemBody() {
    if (!Dme().assigGuia.containsKey(assignatura.sigles) || assignatura.guia == null) {
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
    }
    else {
      print('asdf: ' + assignatura.sigles);
    }
  }
}
