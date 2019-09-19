import 'package:flutter/material.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/blocs/login/login.dart';
import 'package:raco/src/blocs/translations/translations.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';

typedef OnChangeLanguagePressedCallback = Function(String code);

class LoginRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      builder: (context) {
        return LoginBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        );
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {

          final _loginBloc = BlocProvider.of<LoginBloc>(context);
          final _translationBloc = BlocProvider.of<TranslationsBloc>(context);

          _onLoginButtonPressed() {
            _loginBloc.dispatch(LoginButtonPressedEvent(context: context));
          }

          _onVisitButtonPressed() {
            _loginBloc.dispatch(VisitButtonPressedEvent());
          }

          _onChangeLanguagePressed(String code) {
            _translationBloc.dispatch(TranslationsChangedEvent(newLangCode: code));
          }

          
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              children: <Widget>[logoSection(), titleSection(), loginButtonsSection(() => _onLoginButtonPressed(), () => _onVisitButtonPressed()), languageSection(_onChangeLanguagePressed)],
            ),
          );
        },
      ),
    );

  }

  Widget logoSection() {
    return Container(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(50), left: ScreenUtil().setWidth(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/upc_logo_white.png',
            width: ScreenUtil().setWidth(100),
            height: ScreenUtil().setWidth(100),
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/fib_logo.png',
            width: ScreenUtil().setWidth(200),
            height: ScreenUtil().setWidth(200),
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget titleSection() {
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: ScreenUtil().setSp(50),
            color: Colors.white,
          ),
          children: <TextSpan>[
            new TextSpan(text: 'el '),
            new TextSpan(
                text: 'racó',
                style: new TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget loginButtonsSection(VoidCallback onLoginTap, VoidCallback onVisitTap) {

    return Container(
      height: 210,
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(90)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ButtonTheme(
            minWidth: ScreenUtil().setWidth(260),
            height: ScreenUtil().setWidth(45),
            buttonColor: Colors.white,
            child: RaisedButton(
                child: Text(
                  allTranslations.text('signin'),
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    color: AppColors.primary,
                  ),
                ),
                color: Colors.white,
                onPressed: () => onLoginTap(),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30))),
          ),
          ButtonTheme(
            minWidth: ScreenUtil().setWidth(260),
            height: ScreenUtil().setWidth(45),
            buttonColor: Colors.white,
            child: RaisedButton(
                child: Text(
                  allTranslations.text('guest_signin'),
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    color: AppColors.primary,
                  ),
                ),
                color: Colors.white,
                onPressed: () => onVisitTap(),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30))),
          ),
        ],
      ),
    );
  }

  Widget languageSection(OnChangeLanguagePressedCallback _onPressed) {
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(90)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            child: Text(
              allTranslations.text('en'),
            ),
            onPressed: () => _onPressed('en'),
          ),
          RaisedButton(
            child: Text(
              allTranslations.text('es'),
            ),
            onPressed: () => _onPressed('es'),
          ),
          RaisedButton(
            child: Text(
              allTranslations.text('ca'),
            ),
            onPressed: () => _onPressed('ca'),
          ),
        ],
      ),
    );
  }
}
