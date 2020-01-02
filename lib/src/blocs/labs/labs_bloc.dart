import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:oauth2/oauth2.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/blocs/labs/labs.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/raco_api_client.dart';
import 'package:raco/src/repositories/raco_repository.dart';
import 'package:raco/src/resources/authentication_data.dart';
import 'package:raco/src/repositories/user_repository.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/keys.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:http/http.dart' as http;

class LabsBloc extends Bloc<LabsEvent, LabsState> {
  final AuthenticationBloc authenticationBloc;

  LabsBloc({
    @required this.authenticationBloc,
  }) : assert(authenticationBloc != null);


  LabsState get initialState => LabsInitState();

  @override
  Stream<LabsState> mapEventToState(LabsEvent event) async* {
    if (event is LabsInitEvent) {
      yield LabsInitState();
    }
    if (event is LabsChangedEvent) {
      Credentials c = await user.getCredentials();
      try {
        if(c.isExpired) {
          c = await c.refresh(identifier: AuthenticationData.identifier,secret: AuthenticationData.secret,);
          await user.persistCredentials(c);
        }
      } catch(e) {
        authenticationBloc.dispatch(LoggedOutEvent());
      }
      //update news
      bool canUpdate = true;
      if (await user.isPresentInPreferences(Keys.LAST_LABS_REFRESH)) {
        if (DateTime.now().difference(DateTime.parse(await user.readFromPreferences(Keys.LAST_LABS_REFRESH))).inMinutes < 5) {
          canUpdate = false;
        }
      }
      if (canUpdate) {
        try {
          String accessToken = await user.getAccessToken();
          String lang = await user.getPreferredLanguage();
          RacoRepository rr = new RacoRepository(
              racoApiClient: RacoApiClient(
                  httpClient: http.Client(), accessToken: accessToken, lang: lang));
          File f = new File(Dme().A5);
          f.deleteSync();
          File f2 = new File(Dme().B5);
          f2.deleteSync();
          File f3 = new File(Dme().C6);
          f3.deleteSync();
          imageCache.clear();
          Dme().A5 =  await rr.getImageA5();
          Dme().B5 =  await rr.getImageB5();
          Dme().C6 =  await rr.getImageC6();
          user.writeToPreferences('a5', Dme().A5);
          user.writeToPreferences('b5', Dme().B5);
          user.writeToPreferences('c6', Dme().C6);

          user.writeToPreferences(Keys.LAST_LABS_REFRESH, DateTime.now().toIso8601String());
          yield UpdateLabsSuccessfullyState();
        } catch (e) {
          yield UpdateLabsErrorState();
        }
      } else {
        yield UpdateLabsTooFrequentlyState();
      }
    }
  }
}
