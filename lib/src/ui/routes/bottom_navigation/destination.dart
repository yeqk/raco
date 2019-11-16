import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:raco/src/resources/global_translations.dart';

class Destination {
  const Destination(this.index,this.title, this.icon, this.color);
  final int index;
  final String title;
  final IconData icon;
  final MaterialColor color;
}

List<Destination> allDestinations = <Destination>[
  Destination(0, allTranslations.text('schedule'), Icons.schedule, Colors.lightBlue),
  Destination(1, allTranslations.text('notices'), Icons.notifications, Colors.lightBlue),
  Destination(2, allTranslations.text('events'), Icons.event, Colors.lightBlue),
  Destination(3, allTranslations.text('news'), Icons.library_books, Colors.lightBlue)
];