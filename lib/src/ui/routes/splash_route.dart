import 'package:flutter/material.dart';
import 'package:raco/src/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ScreenUtil.instance = ScreenUtil(width: 411.42857142857144, height: 683.4285714285714, allowFontScaling: true)..init(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
      ),
    );
  }
}