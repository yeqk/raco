import 'package:flutter/material.dart';
import 'package:raco/src/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ScreenUtil.instance = ScreenUtil(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, allowFontScaling: true)..init(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print('WIDHT: ' + width.toString());
    print('HEIGH: ' + height.toString());
    return Scaffold(
      backgroundColor: AppColors().primary,
      body: Center(
      ),
    );
  }
}