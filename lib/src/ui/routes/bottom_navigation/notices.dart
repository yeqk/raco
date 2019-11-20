import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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

class NoticiesState extends State<Notices> with SingleTickerProviderStateMixin {
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
    List<Tab> tabs = [
      Tab(
        text: allTranslations.text('all'),
      )
    ];
    tabs.addAll(assignatures.results.map((Assignatura a) {
      print(a.nom);
      return Tab(
        text: a.id,
      );
    }).toList());
    return tabs;
  }

  //---------------------------
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  //_------------------------------------
  List<Widget> _tabViews() {
    List<Container> tabViews = [
      Container(
        child: Container(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: BezierCircleHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemBuilder: (c, i) => Card(child: Center(child: Text(items[i]))),
              itemExtent: 100.0,
              itemCount: items.length,
            ),
          ),
        ),
      )
    ];
    tabViews.addAll(assignatures.results.map((Assignatura a) {
      return Container(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: BezierCircleHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemBuilder: (c, i) => Card(child: Center(child: Text(items[i]))),
            itemExtent: 100.0,
            itemCount: items.length,
          ),
        ),
      );
    }).toList());
    return tabViews;
  }
}
