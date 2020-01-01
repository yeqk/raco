import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/raco_api_client.dart';
import 'package:raco/src/repositories/raco_repository.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/keys.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:http/http.dart' as http;

import 'news.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {

  NewsState get initialState => NewsInitState();

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is NewsInitEvent) {
      yield NewsInitState();
    }
    if (event is NewsChangedEvent) {
      //update news
      bool canUpdate = true;
      if (await user.isPresentInPreferences(Keys.LAST_NEWS_REFRESH)) {
        if (DateTime.now()
            .difference(DateTime.parse(
            await user.readFromPreferences(Keys.LAST_NEWS_REFRESH)))
            .inMinutes <
            5) {
          canUpdate = false;
        }
      }
      if (canUpdate) {
        try {
          String accessToken = await user.getAccessToken();
          String lang = await user.getPreferredLanguage();
          RacoRepository rr = new RacoRepository(
              racoApiClient: RacoApiClient(
                  httpClient: http.Client(),
                  accessToken: accessToken,
                  lang: lang));
          Noticies noticies = await rr.getNoticies();
          await ReadWriteFile()
              .writeStringToFile(FileNames.NOTICIES, jsonEncode(noticies));
          Dme().noticies = noticies;
          user.writeToPreferences(
              Keys.LAST_NEWS_REFRESH, DateTime.now().toIso8601String());
          yield UpdateNewsSuccessfullyState();
        } catch (e) {
          yield UpdateNewsErrorState();
        }
      } else {
        yield UpdateNewsTooFrequentlyState();
      }
    }
  }
}
