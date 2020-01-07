import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:raco/src/blocs/configuration/configuration.dart';
import 'package:raco/src/blocs/events/events.dart';
import 'package:raco/src/blocs/grades/grades.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/models/custom_grades.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/raco_api_client.dart';
import 'package:raco/src/repositories/raco_repository.dart';
import 'package:raco/src/repositories/user_repository.dart';
import 'package:raco/src/ui/routes/bottom_navigation/events_route.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/keys.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:http/http.dart' as http;

class ConfigurationBloc extends Bloc<ConfigurationEvent, ConfigurationState> {

  ConfigurationState get initialState => ConfigurationInitState();

  @override
  Stream<ConfigurationState> mapEventToState(ConfigurationEvent event) async* {
   if (event is ChangePrimaryColorEvent) {
     await user.writeToPreferences('primary_color',
        event.colorCode);
     yield PrimaryColorChangedState();
   } else if (event is ChangeSecondaryColorEvent) {
     await user.writeToPreferences('secondary_color',
         event.colorCode);
     yield SecondaryColorChangedState();
   } else if (event is ChangeSubjectColorEvent) {
     Dme().assigColors[event.subject] = event.colorCode;
     await user.writeToPreferences(event.subject, event.colorCode);
     yield SubjectColorChangedState();
   } else if (event is ChangeUpdateOptionsEvent) {
     await user.writeToPreferences(event.option, event.value);
     yield UpdateOptionsChangedState();
   }


  }
}
