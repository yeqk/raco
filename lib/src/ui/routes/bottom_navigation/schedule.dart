import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/resources/global_translations.dart';

class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          days(context),
          Divider(
            color: Colors.grey,
            thickness: 1,
            height: 1,
          ),
          Expanded(
            child: time(context),
          ),
        ],
      ),
    );
  }

  Widget days(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(10), bottom: ScreenUtil().setHeight(5)),
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 6,
            child: Center(
              child: Text(''),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 6,
            child: Center(
              child: Text(allTranslations.text('mon')),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 6,
            child: Center(
              child: Text(allTranslations.text('tue')),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 6,
            child: Center(
              child: Text(allTranslations.text('wed')),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 6,
            child: Center(
              child: Text(allTranslations.text('thu')),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 6,
            child: Center(
              child: Text(allTranslations.text('fri')),
            ),
          ),
        ],
      ),
    );
  }

  Widget time(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Container(
              child: timeRow(context, '8:00', 0),
            ),
          ),
          Expanded(
            child: Container(
              child: timeRow(context, '9:00', 1),
            ),
          ),
          Expanded(
            child: Container(
              child: timeRow(context, '10:00', 2),
            ),
          ),
          Expanded(
            child: Container(
              child: timeRow(context, '11:00', 3),
            ),
          ),
          Expanded(
            child: Container(
              child: timeRow(context, '12:00', 4),
            ),
          ),
          Expanded(
            child: Container(
              child: timeRow(context, '13:00', 5),
            ),
          ),
          Expanded(
            child: Container(
              child: timeRow(context, '14:00', 6),
            ),
          ),
          Expanded(
            child: Container(
              child: timeRow(context, '15:00', 7),
            ),
          ),
          Expanded(
            child: Container(
              child: timeRow(context, '16:00', 8),
            ),
          ),
          Expanded(
            child: Container(
              child: timeRow(context, '17:00', 9),
            ),
          ),
          Expanded(
            child: Container(
              child: timeRow(context, '18:00', 10),
            ),
          ),
          Expanded(
            child: Container(
              child: timeRow(context, '19:00', 11),
            ),
          ),
          Expanded(
            child: Container(
              child: timeRow(context, '20:00', 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget timeRow(BuildContext context, String time, int index) {
    Color rowColor;
    if (index.isEven) {
      rowColor = Colors.white;
    } else {
      rowColor = Colors.black12;
    }
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Center(
                      child: Text(time),
                    ),
                  ),
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                ),
              ],
            ),
          ),
          Container(
            color: rowColor,
            width: MediaQuery.of(context).size.width / 6,
            child: Center(
              child: _elemtnt(index, 0, context),
            ),
          ),
          Container(
            color: rowColor,
            width: MediaQuery.of(context).size.width / 6,
            child: Center(
              child: _elemtnt(index, 1, context),
            ),
          ),
          Container(
            color: rowColor,
            width: MediaQuery.of(context).size.width / 6,
            child: Center(
              child: _elemtnt(index, 2, context),
            ),
          ),
          Container(
            color: rowColor,
            width: MediaQuery.of(context).size.width / 6,
            child: Center(
              child: _elemtnt(index, 3, context),
            ),
          ),
          Container(
            color: rowColor,
            width: MediaQuery.of(context).size.width / 6,
            child: Center(
              child: _elemtnt(index, 4, context),
            ),
          ),
        ],
      ),
    );
  }

/*
  Widget _elemtnt(int row, int col) {
    Map<int,Map<int,Classe>> sched = Dme().schedule;
    if (sched.containsKey(row)) {
      Map<int,Classe> days = sched[row];
      if (days.containsKey(col)) {
        Classe classe = days[col];
        return Text(classe.codiAssig);
      }
    }
    return Text('');
  }
  */
  Widget _elemtnt(int row, int col, BuildContext context) {
    String key = row.toString() + '|' + col.toString();
    Map<String, Classe> sched = Dme().schedule;

    // int colorValue = int.parse(Dme().assigColors[sched[key].codiAssig]);
    if (sched.containsKey(key)) {
      int codi = int.parse(Dme().assigColors[sched[key].codiAssig]);
      String cont =
          sched[key].codiAssig + ' ' + sched[key].grup + ' ' + sched[key].tipus;
      return Container(
        width: MediaQuery.of(context).size.width / 6,
        color: Color(codi),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FittedBox(
              child: Text(cont),
            ),
            FittedBox(
              child: Text(sched[key].aules),
            )
          ],
        ),
      );
    }
    return Text('');
  }
}