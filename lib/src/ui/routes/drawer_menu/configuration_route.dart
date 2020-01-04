import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:oauth2/oauth2.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/blocs/configuration/configuration.dart';
import 'package:raco/src/blocs/translations/translations.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/repositories/user_repository.dart';
import 'package:raco/src/utils/app_colors.dart';
import 'package:raco/src/utils/keys.dart';
import 'package:intl/intl.dart';

import 'subject_colors.dart';

class ConfigurationRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConfigurationRouteState();
  }
}

class ConfigurationRouteState extends State<ConfigurationRoute>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _configurationBloc = BlocProvider.of<ConfigurationBloc>(context);
    final _translationBloc = BlocProvider.of<TranslationsBloc>(context);
    final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _onLanguageButtonPressed() async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return new SimpleDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
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

    _onSubjectSelected() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SubjectColors()),
      );
    }
    _onUpdateData() async{
      if (DateTime.now().difference(DateTime.parse(await user.readFromPreferences(Keys.LAST_UPDATE))).inMinutes < 5) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(allTranslations.text('wait')),
        ));
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Credentials c = await user.getCredentials();
        _authenticationBloc.dispatch(LoggedInEvent(credentials: c));
      }

    }
    _onSelectColor(String mode) {

      Color s = AppColors().primary;
      if (mode == 's') {
        s = AppColors().accentColor;
      } else if (mode == 'p') {
        s = AppColors().primary;
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: Text(
                allTranslations.text('select_color'),
                overflow: TextOverflow.visible,
              ),
              content: SingleChildScrollView(
                child: MaterialPicker(
                  pickerColor: s,
                  onColorChanged: (Color c) {
                    s = c;
                  },
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    allTranslations.text('default'),
                    overflow: TextOverflow.visible,
                  ),
                  onPressed: () {
                    if (mode == 'p') {
                      AppColors().primary = AppColors().default_primary;
                      _configurationBloc.dispatch(ChangePrimaryColorEvent(colorCode: AppColors().default_primary.value.toString()));
                    } else if (mode == 's') {
                      AppColors().accentColor = AppColors().default_accentColor;
                      _configurationBloc.dispatch(ChangePrimaryColorEvent(colorCode: AppColors().default_accentColor.value.toString()));
                    }
                    String cur = allTranslations.currentLanguage;
                    String an;
                    if (cur == 'es') {
                      an = 'en';
                    } else if (cur == 'ca') {
                      an = 'en';
                    } else {
                      an = 'ca';
                    }
                    _translationBloc
                        .dispatch(TranslationsChangedEvent(newLangCode: an));
                    _translationBloc
                        .dispatch(TranslationsChangedEvent(newLangCode: cur));
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    allTranslations.text('cancel'),
                    overflow: TextOverflow.visible,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    allTranslations.text('accept'),
                    overflow: TextOverflow.visible,
                  ),
                  onPressed: () {
                    if (mode == 'p') {
                      AppColors().primary = s;
                      _configurationBloc.dispatch(ChangePrimaryColorEvent(colorCode: s.value.toString()));
                    } else if (mode == 's') {
                      AppColors().accentColor = s;
                      _configurationBloc.dispatch(ChangePrimaryColorEvent(colorCode: s.value.toString()));

                    }
                    String cur = allTranslations.currentLanguage;
                    String an;
                    if (cur == 'es') {
                      an = 'en';
                    } else if (cur == 'ca') {
                      an = 'en';
                    } else {
                      an = 'ca';
                    }
                    _translationBloc
                        .dispatch(TranslationsChangedEvent(newLangCode: an));
                    _translationBloc
                        .dispatch(TranslationsChangedEvent(newLangCode: cur));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(allTranslations.text('configuration')),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              _language(() => _onLanguageButtonPressed()),
              Divider(),
              _selectColor(allTranslations.text('primary_color'),
                  () => _onSelectColor('p')),
              Divider(),
              _selectColor(allTranslations.text('secondary_color'),
                  () => _onSelectColor('s')),
              Divider(),
              _subjectColor(() => _onSubjectSelected()),
              Divider(),
              _updateData(() => _onUpdateData())
            ],
          ),
        ));
  }

  Widget _subjectColor(VoidCallback onSubjectTap) {
    return ListTile(
      onTap: () => onSubjectTap(),
      title: Text(
        allTranslations.text('assig_colors'),
        overflow: TextOverflow.visible,
      ),
    );
  }

  Widget _selectColor(String t, VoidCallback onColorTap) {
    return ListTile(
      onTap: () => onColorTap(),
      trailing: t == allTranslations.text('primary_color')
          ? CircleAvatar(
              backgroundColor: AppColors().primary,
            )
          : CircleAvatar(
              backgroundColor: AppColors().accentColor,
            ),
      title: Text(
        t,
        overflow: TextOverflow.visible,
      ),
    );
  }

  Widget _language(VoidCallback onLanguageTap) {
    return ListTile(
      onTap: () => onLanguageTap(),
      leading: Icon(Icons.language),
      title: Text(
        allTranslations.text('language'),
        overflow: TextOverflow.visible,
      ),
    );
  }

  Widget _updateData(VoidCallback onTap) {
    return ListTile(
      onTap: () => onTap(),
      leading: Icon(Icons.refresh),
      title: Text(
        allTranslations.text('update_data'),
        overflow: TextOverflow.visible,
      ),
      subtitle: Text(_updateText(), overflow: TextOverflow.visible,),
    );
  }

  String _updateText() {
    DateTime t = DateTime.parse(Dme().lastUpdate);
    DateFormat format = DateFormat.yMd(allTranslations.currentLanguage).add_Hm();
    String res = allTranslations.text('last_update') + ': ' + format.format(t);
    return res;
  }
}
