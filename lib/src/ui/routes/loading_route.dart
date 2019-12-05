import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raco/src/ui/widgets/loading_text.dart';
import 'package:raco/src/utils/app_colors.dart';
import 'package:flutter/widgets.dart';

class LoadingRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors().primary,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[LoadingText()],
                ),
              )
            ],
          ),
        ));
  }
}
