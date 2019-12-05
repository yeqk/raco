import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raco/src/blocs/loading_text/loading_text.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/data/dme.dart' as prefix0;
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/models/custom_grades.dart';
import 'package:raco/src/models/requisits.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/repositories/repositories.dart';
import 'package:http/http.dart' as http;
import 'package:raco/src/models/models.dart';
import 'package:flutter/painting.dart';
import 'package:raco/src/utils/file_names.dart';
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
      final bool hasCredentials = await user.hasCredentials();
      final bool isVisitor = await user.isLoggedAsVisitor();
      if (hasCredentials) {
        yield AuthenticationLoadingState();
        await _loadData();
        yield AuthenticationAuthenticatedState();
      } else {
        if (isVisitor) {
          yield AuthenticationVisitorLoggedState();
        }
        yield AuthenticationUnauthenticatedState();
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
      loadingTextBloc.dispatch(
          LoadTextEvent(text: allTranslations.text('clossing_loading')));
      if (await user.isLoggedAsVisitor()) {
        await user.deleteVisitor();
      }
      if (await user.hasCredentials()) {
        //Clear image cache to update avatar
        imageCache.clear();
        await user.deleteCredentials();
      }
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      var dir = await getApplicationDocumentsDirectory();
      await dir.delete(recursive: true);
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
    loadingTextBloc.dispatch(
        LoadTextEvent(text: allTranslations.text('personal_info_loading')));

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
    String a5Path = directory.path + '/' + FileNames.A5;
    String b5Path = directory.path + '/' + FileNames.B5;
    String c6Path = directory.path + '/' + FileNames.C6;
    Dme().A5 = a5Path;
    Dme().B5 = b5Path;
    Dme().C6 = c6Path;

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
  }

  Future<void> _downloadData() async {
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
    _assignColor(assignatures);
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


    //Custom events
    List<CustomEvent> customEventList = new List<CustomEvent>();
    Dme().customEvents = CustomEvents(0, customEventList);
    await ReadWriteFile().writeStringToFile(
        FileNames.CUSTOM_EVENTS, jsonEncode(Dme().customEvents));
    //Custom grades
    List<CustomGrade> customGradesList = new List<CustomGrade>();
    Dme().customGrades = CustomGrades(0, customGradesList);
    await ReadWriteFile().writeStringToFile(
        FileNames.CUSTOM_GRADES, jsonEncode(Dme().customGrades));
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
    List<int> generatedHues = List();
    Random rand = Random();
    Dme().assigColors = new HashMap();
     int minimumSeparation = (360/(assignatures.count*4)).round();
    for (Assignatura a in assignatures.results) {

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
    }
    Dme().defaultAssigColors = Dme().assigColors;
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
