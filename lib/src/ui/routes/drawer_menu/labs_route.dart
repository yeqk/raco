import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meta/meta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:raco/src/blocs/labs/labs.dart';
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
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class LabsRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LabsRouteState();
  }
}

class LabsRouteState extends State<LabsRoute> with SingleTickerProviderStateMixin {
  RefreshController _refreshController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(allTranslations.text('labs')),
        ),
        body: Container(
          child: BlocBuilder<LabsBloc, LabsState>(
            builder: (context, state) {
              final _labsBloc = BlocProvider.of<LabsBloc>(context);
              if (state is UpdateLabsErrorState) {
                _refreshController.refreshCompleted();
                WidgetsBinding.instance.addPostFrameCallback((_) => _showMessage('Error',context));
                _labsBloc.dispatch(LabsInitEvent());
              } else if (state is UpdateLabsTooFrequentlyState) {
                _refreshController.refreshCompleted();
                WidgetsBinding.instance.addPostFrameCallback((_) => _showMessage(allTranslations.text('wait'),context));
                _labsBloc.dispatch(LabsInitEvent());
              } else if (state is UpdateLabsSuccessfullyState) {
                _refreshController.refreshCompleted();
                _labsBloc.dispatch(LabsInitEvent());
              /*  WidgetsBinding.instance.addPostFrameCallback((_) =>    setState(() {

                }));*/
              }
              return SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: BezierCircleHeader(),
                controller: _refreshController,
                onRefresh: () => _onRefresh(_labsBloc),
                child: _labsList(),
              );

            },
          ),
        ));


  }

  void _showMessage(String msg, BuildContext context)
  {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  Widget _labsList() {
    return new ListView(
      children: <Widget>[
        Card(
            child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return DetailScreen(Dme().A5, 'imageHero');
                  }));
                },
                child: Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            'A5',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(),
                        Hero(
                          tag: 'imageHero',
                          child: Image.file(File(Dme().A5)),
                        )
                      ],
                    )))),
        Card(
            child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return DetailScreen(Dme().B5, 'imageHero1');
                  }));
                },
                child: Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            'B5',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(),
                        Hero(
                          tag: 'imageHero1',
                          child: Image.file(File(Dme().B5)),
                        )
                      ],
                    )))),
        Card(
            child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return DetailScreen(Dme().C6, 'imageHero2');
                  }));
                },
                child: Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                    child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        'C6',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(),
                    Hero(
                      tag: 'imageHero2',
                      child: Image.file(File(Dme().C6)),
                    )
                  ],
                )))),
      ],
    );
  }

  void _onRefresh(var _labsBloc) async {
    _labsBloc.dispatch(LabsChangedEvent());
  }
}

class DetailScreen extends StatelessWidget {
  final String imgPath;
  final String tag;

  DetailScreen(this.imgPath, this.tag);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        body: Container(
            child: InkWell(
      onTap: () {
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        Navigator.pop(context);
      },
      child: Hero(
          tag: tag,
          child: Image.file(File(imgPath),
              fit: BoxFit.contain,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center)),
    )));
  }
}
