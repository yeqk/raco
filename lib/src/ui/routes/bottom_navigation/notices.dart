import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/resources/global_translations.dart';

class Notices extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoticiesState();
  }


}

class NoticiesState extends State<Notices> with SingleTickerProviderStateMixin{
  Assignatures assignatures = Dme().assignatures;
  TabController _tabController;

  @override
  void initState() {
    int size = assignatures.count + 1;
    _tabController = new TabController(length: size, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: TabBar(
        controller: _tabController,
        tabs: _tabs(),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabViews(),
      ),
    );
  }

  List<Widget> _tabs() {
    List<Tab> tabs = [Tab(text: allTranslations.text('all'),)];
    tabs.addAll(assignatures.results.map((Assignatura a) {
      print(a.nom);
      return Tab(text: a.id,);
    }).toList());
    return tabs;
  }

  List<Widget> _tabViews() {
    List<Container> tabViews = [Container(color: Colors.lightGreen, child: Text('all'),)];
    tabViews.addAll(assignatures.results.map((Assignatura a) {
      return Container(
        child: Text(a.id),
      );
    }).toList());
    return tabViews;
  }

}
