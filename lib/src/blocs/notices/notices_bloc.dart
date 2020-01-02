import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:oauth2/oauth2.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
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

import 'Notices.dart';

class NoticesBloc extends Bloc<NoticesEvent, NoticesState> {
  final AuthenticationBloc authenticationBloc;

  NoticesBloc({
    @required this.authenticationBloc,
  }) : assert(authenticationBloc != null);

  NoticesState get initialState => NoticesInitState();

  @override
  Stream<NoticesState> mapEventToState(NoticesEvent event) async* {
    if (event is NoticesInitEvent) {
      yield NoticesInitState();
    }
    if (event is NoticesChangedEvent) {
      Credentials c = await user.getCredentials();
      try {
        if(c.isExpired ) {
          c = await c.refresh(identifier: AuthenticationData.identifier,secret: AuthenticationData.secret,);
          await user.persistCredentials(c);
        }
      } catch(e) {
        authenticationBloc.dispatch(LoggedOutEvent());
      }
      //update notices
      bool canUpdate = true;
      if (await user.isPresentInPreferences(Keys.LAST_NOTICES_REFRESH)) {
        if (DateTime.now().difference(DateTime.parse(await user.readFromPreferences(Keys.LAST_NOTICES_REFRESH))).inMinutes < 5) {
          canUpdate = false;
        }
      }
      if (canUpdate)
      {
        try{
          String accessToken = await user.getAccessToken();
          String lang = await user.getPreferredLanguage();
          RacoRepository rr = new RacoRepository(
              racoApiClient: RacoApiClient(
                  httpClient: http.Client(), accessToken: accessToken, lang: lang));
          Avisos avisos = await rr.getAvisos();
          Dme().avisos = avisos;
          await ReadWriteFile()
              .writeStringToFile(FileNames.AVISOS, jsonEncode(avisos));
          user.writeToPreferences(Keys.LAST_NOTICES_REFRESH, DateTime.now().toIso8601String());
          yield UpdateNoticesSuccessfullyState();
        }catch(e) {
          yield UpdateNoticesErrorState();
        }
      } else {
        yield UpdateNoticesTooFrequentlyState();
      }
    }
  }
}
