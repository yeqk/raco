import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:oauth2/oauth2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raco/src/blocs/loading_text/loading_text.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/data/dme.dart' as prefix0;
import 'package:raco/src/models/custom_downloads.dart';
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/models/custom_grades.dart';
import 'package:raco/src/models/requisits.dart';
import 'package:raco/src/resources/authentication_data.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/repositories/user_repository.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/repositories/repositories.dart';
import 'package:http/http.dart' as http;
import 'package:raco/src/models/models.dart';
import 'package:flutter/painting.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/keys.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
      bool hasCredentials = await user.hasCredentials();

      if (hasCredentials) {
        yield AuthenticationLoadingState();
        try{
          await _loadData();
          Dme().lastUpdate = await user.readFromPreferences(Keys.LAST_UPDATE);
          yield AuthenticationAuthenticatedState();
        }catch (e) {
          loadingTextBloc
              .dispatch(LoadTextEvent(text: allTranslations.text('error_loading')));
          if (await user.hasCredentials()) {
            //Clear image cache to update avatar
            imageCache.clear();
            await user.deleteCredentials();
          }
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear();
          var dir = await getApplicationDocumentsDirectory();
          List<FileSystemEntity> _files;
          _files = dir.listSync(recursive: true, followLinks: false);
          for (FileSystemEntity f in _files) {
            if (!f.path.contains('flutter_assets')) {
              f.deleteSync(recursive: false);
            }
          }
          await dbRepository.closeDB();
          await dbRepository.deleteDB();
          await Future.delayed(Duration(seconds:2));
          yield AuthenticationUnauthenticatedState();
        }

      } else {
        yield AuthenticationUnauthenticatedState();
      }
    }

    if (event is LoggedInEvent) {
      yield AuthenticationLoadingState();
      bool firsLogin = !await user.hasCredentials();
      await user.persistCredentials(event.credentials);
      try {
        if (!firsLogin) {
          Credentials c = await user.getCredentials();
          if(c.isExpired) {
            c = await c.refresh(identifier: AuthenticationData.identifier,secret: AuthenticationData.secret,);
            await user.persistCredentials(c);
          }
        }
        await _downloadData(firsLogin);
        String u = DateTime.now().toIso8601String();
        Dme().lastUpdate = u;
        user.writeToPreferences(Keys.LAST_UPDATE, u);
        yield AuthenticationAuthenticatedState();
      }catch(e) {
        loadingTextBloc
            .dispatch(LoadTextEvent(text: allTranslations.text('error_loading')));
        await Future.delayed(Duration(seconds:2));
        if (firsLogin) {
          if (await user.hasCredentials()) {
            //Clear image cache to update avatar
            imageCache.clear();
            await user.deleteCredentials();
          }
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear();
          var dir = await getApplicationDocumentsDirectory();
          List<FileSystemEntity> _files;
          _files = dir.listSync(recursive: true, followLinks: false);
          for (FileSystemEntity f in _files) {
            if (!f.path.contains('flutter_assets')) {
              f.deleteSync(recursive: false);
            }
          }
          await dbRepository.closeDB();
          await dbRepository.deleteDB();
          yield AuthenticationUnauthenticatedState();
        } else {
          yield AuthenticationAuthenticatedState();
        }

      }
    }

    if (event is LoggedOutEvent) {
      yield AuthenticationLoadingState();
      loadingTextBloc.dispatch(
          LoadTextEvent(text: allTranslations.text('clossing_loading')));
      if (await user.hasCredentials()) {
        //Clear image cache to update avatar
        imageCache.clear();
        await user.deleteCredentials();
      }
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Directory dir = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> _files;
      _files = dir.listSync(recursive: true, followLinks: false);
      for (FileSystemEntity f in _files) {
        if (!f.path.contains('flutter_assets')) {
          f.deleteSync(recursive: false);
        }
      }
      await dbRepository.closeDB();
      await dbRepository.deleteDB();
      yield AuthenticationUnauthenticatedState();
    }
  }

  Future<void> _loadData() async {

    await dbRepository.openDB();

    //load personal information
    loadingTextBloc.dispatch(
        LoadTextEvent(text: allTranslations.text('personal_info_loading')));

    //singleton data object
    Dme dme = Dme();
    //read data from local files
    /*Me me = Me.fromJson(
        jsonDecode(await ReadWriteFile().readStringFromFile(FileNames.JO)));*/

    Me me = await dbRepository.getMe();

    final directory = await getApplicationDocumentsDirectory();
    dme.imgPath = directory.path + '/' + FileNames.AVATAR;
    dme.username = me.username;
    dme.nom = me.nom;
    dme.cognoms = me.cognoms;
    dme.email = me.email;

    //Load schedule information
    loadingTextBloc.dispatch(
        LoadTextEvent(text: allTranslations.text('schedule_loading')));
    Classes classes = Classes.fromJson(jsonDecode(
        await ReadWriteFile().readStringFromFile(FileNames.CLASSES)));
    _fillSchedule(classes);

    //Load notices information
    loadingTextBloc
        .dispatch(LoadTextEvent(text: allTranslations.text('notices_loading')));
    Avisos avisos = Avisos.fromJson(
        jsonDecode(await ReadWriteFile().readStringFromFile(FileNames.AVISOS)));
    dme.avisos = avisos;

    //Load events
    loadingTextBloc
        .dispatch(LoadTextEvent(text: allTranslations.text('events_loading')));
    Events events = Events.fromJson(
        jsonDecode(await ReadWriteFile().readStringFromFile(FileNames.EVENTS)));
    dme.events = events;

    //Load news
    loadingTextBloc
        .dispatch(LoadTextEvent(text: allTranslations.text('news_loading')));
    Noticies noticies = Noticies.fromJson(jsonDecode(
        await ReadWriteFile().readStringFromFile(FileNames.NOTICIES)));
    Dme().noticies = noticies;

    //Load subjects information
    loadingTextBloc.dispatch(
        LoadTextEvent(text: allTranslations.text('subjects_loading')));
    Assignatures assignatures = Assignatures.fromJson(jsonDecode(
        await ReadWriteFile().readStringFromFile(FileNames.ASSIGNATURES)));
    dme.assignatures = assignatures;
    _loadSubjectColor(assignatures);
    dme.assigGuia = new HashMap();
    dme.assigURL = new HashMap();
    for (Assignatura a in assignatures.results) {
      AssignaturaURL assigURL = AssignaturaURL.fromJson(jsonDecode(
          await ReadWriteFile().readStringFromFile(FileNames.ASSIGNATURA_URL + a.id)));
      dme.assigURL[a.id] = assigURL;
      String assigGuiaString =
          await ReadWriteFile().readStringFromFile(FileNames.ASSIGNATURA_GUIA + a.id);
      if (assigGuiaString != 'null') {
        AssignaturaGuia assigGuia =
            AssignaturaGuia.fromJson(jsonDecode(assigGuiaString));
        dme.assigGuia[a.id] = assigGuia;
      }
    }
    Requisits requisits = Requisits.fromJson(jsonDecode(
        await ReadWriteFile().readStringFromFile(FileNames.REQUISITS)));
    dme.requisits = requisits;

    //Load exams
    loadingTextBloc
        .dispatch(LoadTextEvent(text: allTranslations.text('exam_loading')));
    ExamensLaboratori labExams = ExamensLaboratori.fromJson(jsonDecode(
        await ReadWriteFile()
            .readStringFromFile(FileNames.EXAMENS_LABORATORI)));
    dme.labExams = labExams;
    Examens examens = Examens.fromJson(jsonDecode(
        await ReadWriteFile().readStringFromFile(FileNames.EXAMENS)));
    dme.examens = examens;

    //Load lab ocupation
    loadingTextBloc
        .dispatch(LoadTextEvent(text: allTranslations.text('labs_loading')));
    Dme().A5 = await user.readFromPreferences('a5');
    Dme().B5 = await user.readFromPreferences('b5');
    Dme().C6 = await user.readFromPreferences('c6');

    //Load custom events
    Dme().customEvents = CustomEvents.fromJson(jsonDecode(
        await ReadWriteFile().readStringFromFile(FileNames.CUSTOM_EVENTS)));
    //remove outdated custom events
    for (CustomEvent e in Dme().customEvents.results) {
      DateTime fie = DateTime.parse(e.fi);
      if (fie.isBefore(DateTime.now())) {
        Dme().customEvents.results.removeWhere((i) {
          return i.id == e.id;
        });
        Dme().customEvents.count -=1;
      }
    }
    await ReadWriteFile().writeStringToFile(
        FileNames.CUSTOM_EVENTS, jsonEncode(Dme().customEvents));

    //Load custom grades
    Dme().customGrades = CustomGrades.fromJson(jsonDecode(
        await ReadWriteFile().readStringFromFile(FileNames.CUSTOM_GRADES)));

    //load custom downloads
    Dme().customDownloads = CustomDownloads.fromJson(jsonDecode(
        await ReadWriteFile().readStringFromFile(FileNames.CUSTOM_DOWNLOADS)));
  }

  Future<void> _downloadData(bool firstLogin) async {
    if (!firstLogin) {
      await dbRepository.closeDB();
      await dbRepository.deleteDB();
    }
    await dbRepository.openDB();

    //load personal information
    loadingTextBloc.dispatch(
        LoadTextEvent(text: allTranslations.text('personal_info_loading')));
    String accessToken = await user.getAccessToken();
    String lang = await user.getPreferredLanguage();
    if (lang == '') {
      await user.setPreferredLanguage(allTranslations.currentLanguage);
      lang = allTranslations.currentLanguage;
    }
    RacoRepository rr = new RacoRepository(
        racoApiClient: RacoApiClient(
            httpClient: http.Client(), accessToken: accessToken, lang: lang));


    Me me = await rr.getMe();
    await dbRepository.insertMe(me);
    me = await dbRepository.getMe();

    //Clear image cache to update avatar
    imageCache.clear();
    String imgPaht = await rr.getImage();

    //singleton data object
    Dme dme = Dme();
    dme.imgPath = imgPaht;
    dme.username = me.username;
    dme.nom = me.nom;
    dme.cognoms = me.cognoms;
    dme.email = me.email;

    await ReadWriteFile().writeStringToFile(FileNames.JO, jsonEncode(me));

    //Schedule information
    loadingTextBloc.dispatch(
        LoadTextEvent(text: allTranslations.text('schedule_loading')));
    Classes classes = await rr.getClasses();
    _fillSchedule(classes);
    await ReadWriteFile()
        .writeStringToFile(FileNames.CLASSES, jsonEncode(classes));

    //Notices information
    loadingTextBloc
        .dispatch(LoadTextEvent(text: allTranslations.text('notices_loading')));
    Avisos avisos = await rr.getAvisos();
    dme.avisos = avisos;
    await ReadWriteFile()
        .writeStringToFile(FileNames.AVISOS, jsonEncode(avisos));

    //Events information
    loadingTextBloc
        .dispatch(LoadTextEvent(text: allTranslations.text('events_loading')));
    Events events = await rr.getEvents();
    dme.events = events;
    await ReadWriteFile()
        .writeStringToFile(FileNames.EVENTS, jsonEncode(events));

    //News information
    loadingTextBloc
        .dispatch(LoadTextEvent(text: allTranslations.text('news_loading')));
    Noticies noticies = await rr.getNoticies();
    Dme().noticies = noticies;
    await ReadWriteFile()
        .writeStringToFile(FileNames.NOTICIES, jsonEncode(noticies));

    //Subjects information
    loadingTextBloc.dispatch(
        LoadTextEvent(text: allTranslations.text('subjects_loading')));
    Assignatures assignatures = await rr.getAssignatures();
    dme.assignatures = assignatures;
    _assignColor(assignatures, firstLogin);
    await ReadWriteFile()
        .writeStringToFile(FileNames.ASSIGNATURES, jsonEncode(assignatures));
    dme.assigURL = new HashMap();
    dme.assigGuia = new HashMap();
    for (Assignatura a in assignatures.results) {
      AssignaturaURL assigURL = await rr.getAssignaturaURL(a);
      await ReadWriteFile()
          .writeStringToFile(FileNames.ASSIGNATURA_URL + a.id, jsonEncode(assigURL));
      dme.assigURL[a.id] = assigURL;
      AssignaturaGuia assigGuia = await rr.getAssignaturaGuia(a);
      await ReadWriteFile()
          .writeStringToFile(FileNames.ASSIGNATURA_GUIA + a.id, jsonEncode(assigGuia));
      dme.assigGuia[a.id] = assigGuia;
    }
    Requisits requisits = await rr.getRequisists();
    dme.requisits = requisits;
    await ReadWriteFile()
        .writeStringToFile(FileNames.REQUISITS, jsonEncode(requisits));

    //Exams information
    loadingTextBloc
        .dispatch(LoadTextEvent(text: allTranslations.text('exam_loading')));
    //Lab exams
    ExamensLaboratori examensLaboratori = await rr.getExamensLaboratori();
    await ReadWriteFile().writeStringToFile(
        FileNames.EXAMENS_LABORATORI, jsonEncode(examensLaboratori));
    dme.labExams = examensLaboratori;
    //Semester to obtain exams information
    Quadrimestre actual = await rr.getQuadrimestreActual();
    await ReadWriteFile()
        .writeStringToFile(FileNames.QUADRIMESTRE, jsonEncode(actual));
    //Get exams
    Examens examens = await rr.getExamens(actual);
    await ReadWriteFile()
        .writeStringToFile(FileNames.EXAMENS, jsonEncode(examens));
    dme.examens = examens;

    //Labs ocupation
    loadingTextBloc
        .dispatch(LoadTextEvent(text: allTranslations.text('labs_loading')));
    Dme().A5 =  await rr.getImageA5();
    Dme().B5 =  await rr.getImageB5();
    Dme().C6 =  await rr.getImageC6();
    user.writeToPreferences('a5', Dme().A5);
    user.writeToPreferences('b5', Dme().B5);
    user.writeToPreferences('c6', Dme().C6);


    //Custom events
    if (await ReadWriteFile().exists(FileNames.CUSTOM_EVENTS)) {
      //Load custom events
      Dme().customEvents = CustomEvents.fromJson(jsonDecode(
          await ReadWriteFile().readStringFromFile(FileNames.CUSTOM_EVENTS)));
    } else {
      List<CustomEvent> customEventList = new List<CustomEvent>();
      Dme().customEvents = CustomEvents(0, customEventList);
      await ReadWriteFile().writeStringToFile(
          FileNames.CUSTOM_EVENTS, jsonEncode(Dme().customEvents));
    }
    //Custom grades
    if (await ReadWriteFile().exists(FileNames.CUSTOM_GRADES)) {
      //Load custom grades
      Dme().customGrades = CustomGrades.fromJson(jsonDecode(
          await ReadWriteFile().readStringFromFile(FileNames.CUSTOM_GRADES)));
    } else {
      List<CustomGrade> customGradesList = new List<CustomGrade>();
      Dme().customGrades = CustomGrades(0, customGradesList);
      await ReadWriteFile().writeStringToFile(
          FileNames.CUSTOM_GRADES, jsonEncode(Dme().customGrades));
    }

    //Custom downloads
    if (await ReadWriteFile().exists(FileNames.CUSTOM_DOWNLOADS)) {
      //Load custom grades
      Dme().customDownloads = CustomDownloads.fromJson(jsonDecode(
          await ReadWriteFile().readStringFromFile(FileNames.CUSTOM_DOWNLOADS)));
    } else {
      List<String> customDownloadsList = new List<String>();
      Dme().customDownloads = CustomDownloads(0, customDownloadsList);
      await ReadWriteFile().writeStringToFile(
          FileNames.CUSTOM_DOWNLOADS, jsonEncode(Dme().customDownloads));
    }

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

  void _assignColor(Assignatures assignatures, bool firstLogin) async {
    List<int> generatedHues = List();
    Random rand = Random();
    Dme().assigColors = new HashMap();
     int minimumSeparation = (360/(assignatures.count*4)).round();
    for (Assignatura a in assignatures.results) {

      if (firstLogin) {
        int genHue = rand.nextInt(361);
        while(!_isValidColor(genHue, minimumSeparation,generatedHues)) {
          genHue = rand.nextInt(361);
        }
        generatedHues.add(genHue);

        HSVColor hsvcolor =
        HSVColor.fromAHSV(1, genHue.toDouble(), 0.5, 0.75);
        Color c = hsvcolor.toColor();
        Dme().assigColors[a.id] = c.value.toString();
        await user.writeToPreferences(a.id, c.value.toString());
        await user.writeToPreferences(a.id + 'default', c.value.toString());
      } else {
        Dme().assigColors[a.id] = await user.readFromPreferences(a.id);
      }
    }
    Dme().defaultAssigColors = new HashMap.from(Dme().assigColors);
  }

  bool _isValidColor(int v, int separation,List<int> generatedHues) {
    for (int i in generatedHues) {
      int diff = v - i;
      if (diff < 0) {
        diff = diff * -1;
      }
      if (diff < separation) {
        return false;
      }
    }
    return true;
  }

  void _loadSubjectColor(Assignatures assignatures) async {
    Dme().assigColors = new HashMap();
    Dme().defaultAssigColors = new HashMap();
    for (Assignatura a in assignatures.results) {
      String colorValue = await user.readFromPreferences(a.id);
      Dme().assigColors[a.id] = colorValue;
      String defaultv = await user.readFromPreferences(a.id + 'default');
      Dme().defaultAssigColors[a.id] = defaultv;
    }
  }
}
