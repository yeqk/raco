import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raco/src/blocs/loading_text/loading_text.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/repositories/repositories.dart';
import 'package:http/http.dart' as http;
import 'package:raco/src/models/models.dart';
import 'package:flutter/painting.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/read_write_file.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoadingTextBloc loadingTextBloc;

  AuthenticationBloc({
    @required this.loadingTextBloc,
  }) : assert(loadingTextBloc != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitializedState();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStartedEvent) {
      final bool hasCredentials = await user.hasCredentials();
      final bool isVisitor = await user.isLoggedAsVisitor();
      if (hasCredentials) {
        yield AuthenticationLoadingState();
        await _loadData();
        yield AuthenticationAuthenticatedState();
      } else {
        if (isVisitor) {
          yield AuthenticationVisitorLoggedState(); 
          yield AuthenticationUnauthenticatedState();
        }
      }
    }

    if (event is LoggedInEvent) {
      yield AuthenticationLoadingState();
      await user.persistCredentials(event.credentials);
      await _downloadData();
      yield AuthenticationAuthenticatedState();
    }

    if (event is LoggedOutEvent) {
      yield AuthenticationLoadingState();
      loadingTextBloc.dispatch(LoadTextEvent(text: allTranslations.text('clossing_loading')));
      if (await user.isLoggedAsVisitor()) {
        await user.deleteVisitor();
      }
      if (await user.hasCredentials()) {
        //Clear image cache to update avatar
        imageCache.clear();
        await user.deleteCredentials();
      }
      yield AuthenticationUnauthenticatedState();
    }

    if (event is LoggedAsVisitorEvent) {
      yield AuthenticationLoadingState();
      await user.setLoggedAsVisitor();
      yield AuthenticationVisitorLoggedState();
    }
  }

  Future<void> _loadData() async {
    //load personal information
    loadingTextBloc.dispatch(LoadTextEvent(text: allTranslations.text('personal_info_loading')));
    //singleton data object
    Dme dme = Dme();
    //read data from local files
    Me me = Me.fromJson(
        jsonDecode(await ReadWriteFile().readStringFromFile(FileNames.JO)));
    final directory = await getApplicationDocumentsDirectory();
    dme.imgPath = directory.path + '/' + FileNames.AVATAR;
    dme.username = me.username;
    dme.nom = me.nom;
    dme.cognoms = me.cognoms;
    dme.email = me.email;

    //Load schedule information
    loadingTextBloc.dispatch(LoadTextEvent(text: allTranslations.text('schedule_loading')));
    Classes classes = Classes.fromJson(jsonDecode(
        await ReadWriteFile().readStringFromFile(FileNames.CLASSES)));
    _fillSchedule(classes);

    //Load subjects information
    loadingTextBloc.dispatch(LoadTextEvent(text: allTranslations.text('subjects_loading')));
    Assignatures assignatures = Assignatures.fromJson(jsonDecode(
        await ReadWriteFile().readStringFromFile(FileNames.ASSIGNATURES)));
    _loadSubjectColor(assignatures);

    //Load notices information
    loadingTextBloc.dispatch(LoadTextEvent(text: allTranslations.text('notices')));
    Avisos avisos = Avisos.fromJson(jsonDecode(
        await ReadWriteFile().readStringFromFile(FileNames.AVISOS)));
  }

  Future<void> _downloadData() async {
    //load personal information
    loadingTextBloc.dispatch(LoadTextEvent(text: allTranslations.text('personal_info_loading')));
    RacoRepository rr = new RacoRepository(
        racoApiClient: RacoApiClient(
      httpClient: http.Client(),
    ));
    String accessToken = await user.getAccessToken();
    String lang = await user.getPreferredLanguage();

    Me me = await rr.getMe(accessToken, lang);

    //Clear image cache to update avatar
    imageCache.clear();
    String imgPaht = await rr.getImage(accessToken, lang);

    //singleton data object
    Dme dme = Dme();
    dme.imgPath = imgPaht;
    dme.username = me.username;
    dme.nom = me.nom;
    dme.cognoms = me.cognoms;
    dme.email = me.email;

    await ReadWriteFile().writeStringToFile(FileNames.JO, jsonEncode(me));

    //Schedule information
    loadingTextBloc.dispatch(LoadTextEvent(text: allTranslations.text('schedule_loading')));
    Classes classes = await rr.getClasses(accessToken, lang);
    _fillSchedule(classes);
    await ReadWriteFile()
        .writeStringToFile(FileNames.CLASSES, jsonEncode(classes));

    //Subjects information
    loadingTextBloc.dispatch(LoadTextEvent(text: allTranslations.text('subjects_loading')));
    Assignatures assignatures = await rr.getAssignatures(accessToken, lang);
    _assignColor(assignatures);
    await ReadWriteFile()
        .writeStringToFile(FileNames.ASSIGNATURES, jsonEncode(assignatures));

    //Notices information
    loadingTextBloc.dispatch(LoadTextEvent(text: allTranslations.text('notices_loading')));
    Avisos avisos = await rr.getAvisos(accessToken, lang);
    await ReadWriteFile()
        .writeStringToFile(FileNames.ASSIGNATURES, jsonEncode(assignatures));
  }

  void _fillSchedule(Classes classes) {
    Map<String, Classe> schedule = new HashMap();
    for (Classe cl in classes.results) {
      //0-4 represents monday-friday
      int col = cl.diaSetmana - 1;
      //0-12 represents 8:00-20:00
      int row = int.parse(cl.inici.split(":").first) - 8;
      for (int i = 0; i < cl.durada; i++) {
        String key = (row + i).toString() + '|' + col.toString();
        schedule[key] = cl;
      }
    }
    Dme dme = Dme();
    dme.schedule = schedule;
  }

  void _assignColor(Assignatures assignatures) async {
    Random rand = Random();
    Dme().assigColors = new HashMap();
    for (Assignatura a in assignatures.results) {
      HSVColor hsvcolor =
          HSVColor.fromAHSV(1, rand.nextInt(361).toDouble(), 0.5, 0.75);
      Color c = hsvcolor.toColor();
      Dme().assigColors[a.id] = c.value.toString();
      await user.writeToPreferences(a.id, c.value.toString());
    }
  }

  void _loadSubjectColor(Assignatures assignatures) async {
    Dme().assigColors = new HashMap();
    for (Assignatura a in assignatures.results) {
      String colorValue = await user.readFromPreferences(a.id);
      Dme().assigColors[a.id] = colorValue;
    }
  }
}
