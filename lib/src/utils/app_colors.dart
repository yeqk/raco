import 'package:flutter/material.dart';

class AppColors {
  static final AppColors _appColors = AppColors._internal();

  factory AppColors() {
    return _appColors;
  }

  AppColors._internal(
      );

  //static const Color primary = const Color(0xff2f9ae5);
  Color default_primary = Color(0xff2f9ae5);
  Color default_accentColor = Colors.lightBlueAccent;
  Color primary = Color(0xff2f9ae5);
  Color accentColor = Colors.lightBlueAccent;

}