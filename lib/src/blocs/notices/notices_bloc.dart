import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:oauth2/oauth2.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/db_helpers/attachment_helper.dart';
import 'package:raco/src/models/db_helpers/notice_helper.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/db_repository.dart';
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
      try {
        Credentials c = await user.getCredentials();
        if(c.isExpired ) {
          c = await c.refresh(identifier: AuthenticationData.identifier,secret: AuthenticationData.secret,);
          await user.persistCredentials(c);
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
          String accessToken = await user.getAccessToken();
          String lang = await user.getPreferredLanguage();
          RacoRepository rr = new RacoRepository(
              racoApiClient: RacoApiClient(
                  httpClient: http.Client(), accessToken: accessToken, lang: lang));
          Avisos avisos = await rr.getAvisos();
          dbRepository.cleanAttachmentHelperTable();
          dbRepository.cleanNoticeHelperTalbe();
          avisos.results.forEach((a) async {
            await dbRepository.insertNoticeHelper(NoticeHelper.fromAvis(a, Dme().username));
            a.adjunts.forEach((adj) async {
              await dbRepository.insertAttachmentHelper(AttachmentHelper.fromAdjunt(adj, a.id));
            });
          });
          Dme().avisos = avisos;
          await ReadWriteFile()
              .writeStringToFile(FileNames.AVISOS, jsonEncode(avisos));
          user.writeToPreferences(Keys.LAST_NOTICES_REFRESH, DateTime.now().toIso8601String());
          yield UpdateNoticesSuccessfullyState();
        } else {
          yield UpdateNoticesTooFrequentlyState();
        }
      } catch(e) {
        yield UpdateNoticesErrorState();
      }

    }
  }
}
