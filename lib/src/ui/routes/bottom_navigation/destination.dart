import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:raco/src/resources/global_translations.dart';

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

List<Destination> allDestinations = <Destination>[
  Destination(allTranslations.text('schedule'), Icons.schedule, Colors.lightBlue),
  Destination(allTranslations.text('notes'), Icons.notifications, Colors.lightBlue),
  Destination(allTranslations.text('events'), Icons.event, Colors.lightBlue),
  Destination(allTranslations.text('news'), Icons.library_books, Colors.lightBlue)
];