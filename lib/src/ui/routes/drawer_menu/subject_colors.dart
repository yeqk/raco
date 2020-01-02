import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:raco/src/blocs/configuration/configuration.dart';
import 'package:raco/src/blocs/translations/translations.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/repositories/user_repository.dart';
import 'package:raco/src/utils/app_colors.dart';

class SubjectColors extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SubjectColorsState();
  }
}

class SubjectColorsState extends State<SubjectColors>
    with SingleTickerProviderStateMixin {
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
    _onSelectColor(String assignatura) {
      Color s = Color(int.parse(Dme().assigColors[assignatura]));
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
                    _configurationBloc.dispatch(ChangeSubjectColorEvent(
                        subject: assignatura,
                        colorCode: Dme().defaultAssigColors[assignatura]));

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
                    _configurationBloc.dispatch(ChangeSubjectColorEvent(
                        subject: assignatura, colorCode: s.value.toString()));

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
        appBar: AppBar(
          title: Text(allTranslations.text('configuration')),
        ),
        body: Container(
          child: ListView(
              children: Dme().assignatures.results.map((a) {
            return ListTile(
              onTap: () => _onSelectColor(a.id),
              title: Text(
                (a.nom != null && a.nom != ' ') ? a.nom : a.sigles,
                overflow: TextOverflow.visible,
              ),
              trailing: CircleAvatar(
                backgroundColor: Color(int.parse(Dme().assigColors[a.sigles])),
              ),
            );
          }).toList()),
        ));
  }
}
