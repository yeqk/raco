import 'dart:convert';

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
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class News extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewsState();
  }
}

class NewsState extends State<News> with SingleTickerProviderStateMixin {
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
    return Container(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: BezierCircleHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: _newsList(),
      ),
    );
  }

  Widget _newsList() {
    List<Noticia> noticies = Dme().noticies.results;
    if (noticies.length == 0) {
      return ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  allTranslations.text('no_news'),
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          )
        ],
      );
    } else {
      return ListView(
        children: noticies.map((Noticia n) {
          return Card(
              child: InkWell(
                onTap: () => _newsTapped(n.link),
            child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    n.titol,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(5),
                  ),
                  _dataPublicacio(n.dataPublicacio),
                  Divider(),
                  Html(
                    data: n.descripcio,
                  )
                ],
              ),
            ),
          ));
        }).toList(),
      );
    }
  }

  void _newsTapped(String url) async{
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }

  Text _dataPublicacio(String data) {
    DateFormat parser = DateFormat('yyyy-M-dTH:m:s');
    DateTime dateTime = parser.parse(data);
    DateFormat formatter =
        DateFormat.yMd(allTranslations.currentLanguage).add_Hm();
    return Text(
      formatter.format(dateTime),
      style: TextStyle(color: Colors.grey),
    );
  }

  void _onRefresh() async {
    //update news
    String accessToken = await user.getAccessToken();
    String lang = await user.getPreferredLanguage();
    RacoRepository rr = new RacoRepository(
        racoApiClient: RacoApiClient(
            httpClient: http.Client(), accessToken: accessToken, lang: lang));
    Noticies noticies = await rr.getNoticies();
    await ReadWriteFile()
        .writeStringToFile(FileNames.NOTICIES, jsonEncode(noticies));
    Dme().noticies = noticies;
    setState(() {});
    _refreshController.refreshCompleted();
  }
}
