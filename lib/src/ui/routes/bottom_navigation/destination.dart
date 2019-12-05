import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/utils/app_colors.dart';

class Destination {
  const Destination(this.index,this.title, this.icon, this.color);
  final int index;
  final String title;
  final IconData icon;
  final Color color;
}

List<Destination> allDestinations = <Destination>[
  Destination(0, 'schedule', Icons.schedule, AppColors().primary),
  Destination(1, 'notices', Icons.notifications, AppColors().primary),
  Destination(2, 'events', Icons.event, AppColors().primary),
  Destination(3, 'news', Icons.library_books, AppColors().primary)
];