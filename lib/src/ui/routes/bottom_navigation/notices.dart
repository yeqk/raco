import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meta/meta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'notice.dart';

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
      print('HHHH:' + a.nom+ ':hhh');
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
            child: ListView(
              children: _avisos(Dme().avisos),
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

  List<Widget> _avisos(Avisos avisos) {
    List<Avis> listAvisos = avisos.results;
    listAvisos.sort((a, b) {
      DateFormat format = DateFormat('yyyy-M-dTH:m:s');
      DateTime ta = format.parse(a.dataModificacio);
      DateTime tb = format.parse(b.dataModificacio);
      return tb.compareTo(ta);
    });

    DateFormat format = DateFormat('yyyy-M-dTH:m:s');
    var formatter = new DateFormat.yMMMMd(allTranslations.currentLanguage);

    return avisos.results.map((Avis avis) {
      Color color;
      if (Dme().assigColors[avis.codiAssig] == null) {
        color = Colors.blueGrey;
      } else {
        int codi = int.parse(Dme().assigColors[avis.codiAssig]);
        color = Color(codi);
      }

      DateTime ta = format.parse(avis.dataModificacio);
      String time = formatter.format(ta);
      if (avis.adjunts.length > 0) {
        return Card(
          child: InkWell(
            onTap: () => _onTap(avis),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: FittedBox(
                  child: Text(avis.codiAssig),
                ),
              ),
              title: Text(avis.titol),
              trailing: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(avis.adjunts.length.toString()),
                    Icon(Icons.attach_file)
                  ],
                ),
              ),
              subtitle: Text(time),
            ),
          ),
        );
      }
      return Card(
        child: InkWell(
          onTap: () => _onTap(avis),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color,
              child: FittedBox(
                child: Text(avis.codiAssig),
              ),
            ),
            title: Text(avis.titol),
            subtitle: Text(time),
          ),
        ),
      );
    }).toList();
  }

/*
  _onTap(Avis avis) {
    print(avis.titol);
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            title: new Text("Dialog Title"),
            content: Container(
              height: 300,
              child: SingleChildScrollView(
                child: Html(
                  data: avis.text,
                  onLinkTap: (url) => _onLinkTap(url),
                ),
              ),
            )));
  }

 */
  _onTap(Avis avis) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Notice(avis: avis)));
  }

  _onLinkTap(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
