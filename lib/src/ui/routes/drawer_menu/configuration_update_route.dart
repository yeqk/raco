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

class ConfigurationUpdateRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConfigurationUpdateRouteState();
  }
}

class ConfigurationUpdateRouteState extends State<ConfigurationUpdateRoute>
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

    return new Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text('update_options')),
        ),
        body: Container(
            child: ListView(children: [
          SwitchListTile(
            title: Text(
              allTranslations.text('personal_info'),
              overflow: TextOverflow.visible,
            ),
            value: Dme().bpersonal,
            onChanged: (bool newValue) {
              _configurationBloc.dispatch(ChangeUpdateOptionsEvent(
                  option: 'personal_info', value: newValue ? 'true' : 'false'));
              setState(() {Dme().bpersonal = newValue;});
              },
          ),
              SwitchListTile(
                title: Text(
                  allTranslations.text('schedule'),
                  overflow: TextOverflow.visible,
                ),
                value: Dme().bschedule,
                onChanged: (bool newValue) {
                  _configurationBloc.dispatch(ChangeUpdateOptionsEvent(
                      option: 'schedule', value: newValue ? 'true' : 'false'));
                  setState(() {Dme().bschedule = newValue;});
                  },
              ),
              SwitchListTile(
                title: Text(
                  allTranslations.text('notices'),
                  overflow: TextOverflow.visible,
                ),
                value: Dme().bnotices,
                onChanged: (bool newValue) {
                  _configurationBloc.dispatch(ChangeUpdateOptionsEvent(
                      option: 'notices', value: newValue ? 'true' : 'false'));
                  setState(() {Dme().bnotices = newValue;});
                  },
              ),
              SwitchListTile(
                title: Text(
                  allTranslations.text('events'),
                  overflow: TextOverflow.visible,
                ),
                value: Dme().bevents,
                onChanged: (bool newValue) {
                  _configurationBloc.dispatch(ChangeUpdateOptionsEvent(
                      option: 'events', value: newValue ? 'true' : 'false'));
                  setState(() {Dme().bevents = newValue;});
                  },
              ),
              SwitchListTile(
                title: Text(
                  allTranslations.text('news'),
                  overflow: TextOverflow.visible,
                ),
                value: Dme().bnews,
                onChanged: (bool newValue) {
                  _configurationBloc.dispatch(ChangeUpdateOptionsEvent(
                      option: 'news', value: newValue ? 'true' : 'false'));
                  setState(() {Dme().bnews = newValue;});
                  },
              ),
              SwitchListTile(
                title: Text(
                  allTranslations.text('subjects'),
                  overflow: TextOverflow.visible,
                ),
                value: Dme().bsubjects,
                onChanged: (bool newValue) {
                  _configurationBloc.dispatch(ChangeUpdateOptionsEvent(
                      option: 'subjects', value: newValue ? 'true' : 'false'));
                  setState(() {Dme().bsubjects = newValue;});
                },
              ),
              SwitchListTile(
                title: Text(
                  allTranslations.text('labs'),
                  overflow: TextOverflow.visible,
                ),
                value: Dme().blabs,
                onChanged: (bool newValue) {
                  _configurationBloc.dispatch(ChangeUpdateOptionsEvent(
                      option: 'labs', value: newValue ? 'true' : 'false'));
                  setState(() {Dme().blabs = newValue;});
                  },
              ),
        ])));
  }
}
