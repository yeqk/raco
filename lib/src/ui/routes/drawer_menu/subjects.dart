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


class Subjects extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SubjectsState();
  }
}

class SubjectsState extends State<Subjects> with SingleTickerProviderStateMixin {
  Assignatures assignatures = Dme().assignatures;
  TabController _tabController;


  @override
  void initState() {
    int size = assignatures.count + 1;
    _tabController = new TabController(length: size, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('subjects')),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabViews(),
      ),
    );
  }

  List<Widget> _tabs() {
    List<Tab> tabs = [
      Tab(
        text: allTranslations.text('all'),
      )
    ];
    tabs.addAll(assignatures.results.map((Assignatura a) {
      return Tab(
        text: a.id,
      );
    }).toList());
    return tabs;
  }


  List<Widget> _tabViews() {
    List<Widget> tabViews = List();
    tabViews.add(Text('all'));
    tabViews.addAll(assignatures.results.map((Assignatura a) {
      return Text(a.id);
    }).toList());
    return tabViews;
  }


}
