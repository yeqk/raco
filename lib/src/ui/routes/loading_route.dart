import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raco/src/blocs/loading_text/loading_text.dart';
import 'package:raco/src/resources/global_translations.dart';
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
class LoadingText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingTextBloc, LoadingTextState>(
      bloc: BlocProvider.of<LoadingTextBloc>(context),
      builder: (context, state) {
        if (state is LoadTextState) {
          return Text(state.text, style: TextStyle(color: Colors.white), overflow: TextOverflow.visible,);
        }
        return Text(allTranslations.text('default_loading'), style: TextStyle(color: Colors.white),overflow: TextOverflow.visible,);
      },
    );
  }
}
