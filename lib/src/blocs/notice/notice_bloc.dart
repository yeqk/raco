import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:oauth2/oauth2.dart';
import 'package:open_file/open_file.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/raco_api_client.dart';
import 'package:raco/src/repositories/raco_repository.dart';
import 'package:raco/src/repositories/user_repository.dart';
import 'package:raco/src/resources/authentication_data.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/keys.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:http/http.dart' as http;
import 'package:share_extend/share_extend.dart';

import 'notice.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {

  NoticeState get initialState => NoticeInitState();

  @override
  Stream<NoticeState> mapEventToState(NoticeEvent event) async* {
    if (event is NoticeInitEvent) {
      yield NoticeInitState();
    }
    if (event is NoticeDownloadAttachmentEvent) {
      Adjunt adjunt = event.adjunt;
      try {
        Credentials c = await user.getCredentials();
        if(c.isExpired ) {
          c = await c.refresh(identifier: AuthenticationData.identifier,secret: AuthenticationData.secret,);
          await user.persistCredentials(c);
        }

        String accessToken = await user.getAccessToken();
        String lang = await user.getPreferredLanguage();
        RacoRepository rr = new RacoRepository(
            racoApiClient: RacoApiClient(
                httpClient: http.Client(), accessToken: accessToken, lang: lang));
        String filePath = '';
        if (await ReadWriteFile().exists(adjunt.nom)) {
          filePath = await ReadWriteFile().getPaht(adjunt.nom);
          if (adjunt.tipusMime == 'application/pdf') {
            await OpenFile.open(filePath);
          } else {
            await ShareExtend.share(filePath, adjunt.nom);
          }
        } else {
          try {
            yield NoticeAttachmentDownloadingState();

            filePath = await rr.downloadAndSaveFile(
                adjunt.nom, adjunt.url, adjunt.tipusMime);
            Dme().customDownloads.count += 1;
            Dme().customDownloads.name.add(adjunt.nom);
            await ReadWriteFile().writeStringToFile(
                FileNames.CUSTOM_DOWNLOADS,
                jsonEncode(Dme().customDownloads));

            yield NoticeAttachmentDownloadSuccessfullyState();

            await Future.delayed(Duration(milliseconds:10));
            if (adjunt.tipusMime == 'application/pdf') {
              await OpenFile.open(filePath);
            } else {
              await ShareExtend.share(filePath, adjunt.nom);
            }
          } catch (e) {
            yield NoticeAttachmentDownloadErrorState();
          }
        }
      } catch (e) {
        yield NoticeAttachmentDownloadErrorState();
      }
    }
  }
}
