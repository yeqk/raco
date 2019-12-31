import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/blocs/login/login.dart';
import 'package:raco/src/blocs/translations/translations.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:flutter/services.dart';
import 'package:raco/src/utils/read_write_file.dart';

typedef OnChangeLanguagePressedCallback = Function(String code);

class LoginRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginRouteState();
  }
}

class LoginRouteState extends State<LoginRoute> {
  bool _value = false;

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
            if (_value) {
              _loginBloc.dispatch(LoginButtonPressedEvent(context: context));
            } else {
              if (Platform.isIOS) {
                showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return new CupertinoAlertDialog(
                        content:
                            new Text(allTranslations.text('please_conditions')),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text(allTranslations.text('accept')),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return new AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        content:
                            new Text(allTranslations.text('please_conditions')),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(allTranslations.text('accept')),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              }
            }
          }

          _onLanguageButtonPressed() async {
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return new SimpleDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        children: <Widget>[
                          new SimpleDialogOption(
                            child: new Text(allTranslations.text('ca')),
                            onPressed: () {
                              _translationBloc.dispatch(
                                  TranslationsChangedEvent(newLangCode: 'ca'));
                              Navigator.of(context).pop();
                            },
                          ),
                          Divider(),
                          new SimpleDialogOption(
                            child: new Text(allTranslations.text('es')),
                            onPressed: () {
                              _translationBloc.dispatch(
                                  TranslationsChangedEvent(newLangCode: 'es'));
                              Navigator.of(context).pop();
                            },
                          ),
                          Divider(),
                          new SimpleDialogOption(
                            child: new Text(allTranslations.text('en')),
                            onPressed: () {
                              _translationBloc.dispatch(
                                  TranslationsChangedEvent(newLangCode: 'en'));
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                });
          }

          if (MediaQuery.of(context).orientation == Orientation.portrait) {
            return FittedBox(
                fit: BoxFit.fill,
                child: Material(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: AppColors().primary,
                    ),
                    child: Column(
                      children: <Widget>[
                        logoSection(context),
                        titleSection(context),
                        loginButtonsSection(() => _onLoginButtonPressed(),
                            () => _onLanguageButtonPressed(), context),
                      ],
                    ),
                  ),
                ));
          } else {
            return Text('');
          }
        },
      ),
    );
  }

  Widget logoSection(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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

  Widget titleSection(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
        child: Center(
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
        ));
  }

  Widget loginButtonsSection(VoidCallback onLoginTap,
      VoidCallback onLanguageTap, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setHeight(100),
          ),
          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 15,
            buttonColor: Colors.white,
            child: RaisedButton(
                child: FittedBox(
                  child: Text(
                    allTranslations.text('signin'),
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      color: AppColors().primary,
                    ),
                  ),
                ),
                color: Colors.white,
                onPressed: () => onLoginTap(),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30))),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 15,
            buttonColor: Colors.white,
            child: RaisedButton.icon(
                icon: Icon(
                  Icons.language,
                  color: AppColors().primary,
                ),
                label: FittedBox(
                  child: Text(
                    allTranslations.text(allTranslations.currentLanguage),
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      color: AppColors().primary,
                    ),
                  ),
                ),
                color: Colors.white,
                onPressed: () => onLanguageTap(),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30))),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: _value,
                onChanged: (bool newValue) {
                  setState(() {
                    _value = newValue;
                  });
                },
              ),
              RichText(
                text: TextSpan(
                  text: allTranslations.text('terms'),
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      File f;
                      if (allTranslations.currentLanguage == 'ca') {
                        f = await copyAsset('terms_conditions_ca.pdf');
                      } else if (allTranslations.currentLanguage == 'es') {
                        f = await copyAsset('terms_conditions_es.pdf');
                      } else if (allTranslations.currentLanguage == 'en') {
                        f = await copyAsset('terms_conditions_en.pdf');
                      }
                      await OpenFile.open(f.path);
                    },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<File> copyAsset(String fileName) async {
    ByteData bd = await rootBundle.load('assets/files/' + fileName);
    return await ReadWriteFile().wirteBytesToFile("terms.pdf", bd);
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }
}
