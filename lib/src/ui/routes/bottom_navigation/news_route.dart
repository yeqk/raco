import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meta/meta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/blocs/news/news.dart';
import 'package:raco/src/blocs/translations/translations.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/repositories.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:intl/intl.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/keys.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class NewsRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return  NewsRouteState();
  }
}

class NewsRouteState extends State<NewsRoute> with SingleTickerProviderStateMixin {
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
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        final _newsBloc = BlocProvider.of<NewsBloc>(context);
        if (state is UpdateNewsErrorState) {
          _refreshController.refreshCompleted();
          WidgetsBinding.instance.addPostFrameCallback((_) => _showMessage('Error'));
          _newsBloc.dispatch(NewsInitEvent());
        } else if (state is UpdateNewsTooFrequentlyState) {
          _refreshController.refreshCompleted();
          WidgetsBinding.instance.addPostFrameCallback((_) => _showMessage(allTranslations.text('wait')));
          _newsBloc.dispatch(NewsInitEvent());
        } else if (state is UpdateNewsSuccessfullyState) {
          _refreshController.refreshCompleted();
          _newsBloc.dispatch(NewsInitEvent());
          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {

          }));
        }
        return Container(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: BezierCircleHeader(),
            controller: _refreshController,
            onRefresh: ()=>_onRefresh(_newsBloc),
            child: _newsList(),
          ),
        );
      },
    );


  }

  void _showMessage(String msg)
  {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
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

  void _newsTapped(String url) async {
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

  void _onRefresh(var _newsBloc) async {
    _newsBloc.dispatch(NewsChangedEvent());

  }
}
