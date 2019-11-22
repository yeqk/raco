import 'dart:convert';
import 'dart:async';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;
import 'package:image/image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/utils/file_names.dart';

class RacoApiClient {
  static const baseUrl = 'https://api.fib.upc.edu/v2';
  final http.Client httpClient;
  String accessToken;
  String lang;

  RacoApiClient(
      {@required this.httpClient,
      @required this.accessToken,
      @required this.lang})
      : assert(httpClient != null && accessToken != null && lang != null);

  Future<Me> getMe() async {
    final locationUrl = '$baseUrl/jo';
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Accept-Language': lang,
      'Authorization': 'Bearer ' + accessToken
    };
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting me information.');
    }
    Map meMap = jsonDecode(utf8.decode(response.bodyBytes));
    return Me.fromJson(meMap);
  }

  Future<String> getImage() async {
    final locationUrl = '$baseUrl/jo/foto.jpg';
    Map<String, String> headers = {'Authorization': 'Bearer ' + accessToken};
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    FileInfo fileInfo = await DefaultCacheManager()
        .downloadFile(locationUrl, authHeaders: headers);
    Io.File file = fileInfo.file;
    Image image = decodeImage(file.readAsBytesSync());
    Io.File imgFile = new Io.File(localPath + '/' + FileNames.AVATAR)
      ..writeAsBytesSync(encodeJpg(image), flush: true);
    return imgFile.path;
  }

  Future<String> getImageA5() async {
    final locationUrl = '$baseUrl/laboratoris/imatges/A5.png';
    Map<String, String> headers = {'Authorization': 'Bearer ' + accessToken};
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    FileInfo fileInfo = await DefaultCacheManager()
        .downloadFile(locationUrl, authHeaders: headers);
    Io.File file = fileInfo.file;
    Image image = decodeImage(file.readAsBytesSync());
    Io.File imgFile = new Io.File(localPath + '/' + FileNames.A5)
      ..writeAsBytesSync(encodePng(image), flush: true);
    return imgFile.path;
  }

  Future<String> getImageC6() async {
    final locationUrl = '$baseUrl/laboratoris/imatges/C6.png';
    Map<String, String> headers = {'Authorization': 'Bearer ' + accessToken};
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    FileInfo fileInfo = await DefaultCacheManager()
        .downloadFile(locationUrl, authHeaders: headers);
    Io.File file = fileInfo.file;
    Image image = decodeImage(file.readAsBytesSync());
    Io.File imgFile = new Io.File(localPath + '/' + FileNames.C6)
      ..writeAsBytesSync(encodePng(image), flush: true);
    return imgFile.path;
  }

  Future<String> getImageB5() async {
    final locationUrl = '$baseUrl/laboratoris/imatges/B5.png';
    Map<String, String> headers = {'Authorization': 'Bearer ' + accessToken};
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    FileInfo fileInfo = await DefaultCacheManager()
        .downloadFile(locationUrl, authHeaders: headers);
    Io.File file = fileInfo.file;
    Image image = decodeImage(file.readAsBytesSync());
    Io.File imgFile = new Io.File(localPath + '/' + FileNames.B5)
      ..writeAsBytesSync(encodePng(image), flush: true);
    return imgFile.path;
  }

  Future<Classes> getClasses() async {
    final locationUrl = '$baseUrl/jo/classes';
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Accept-Language': lang,
      'Authorization': 'Bearer ' + accessToken
    };
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting schedule information.');
    }
    Map classesMap = jsonDecode(utf8.decode(response.bodyBytes));
    return Classes.fromJson(classesMap);
  }

  Future<Assignatures> getAssignatures() async {
    final locationUrl = '$baseUrl/jo/assignatures';
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Accept-Language': lang,
      'Authorization': 'Bearer ' + accessToken
    };
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting subjects information.');
    }
    Map assigMap = jsonDecode(utf8.decode(response.bodyBytes));
    return Assignatures.fromJson(assigMap);
  }

  Future<AssignaturaURL> getAssignaturaURL(Assignatura assignatura) async {
    final locationUrl = assignatura.url;
    if (locationUrl == null) {
      return null;
    }
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Accept-Language': lang,
      'Authorization': 'Bearer ' + accessToken
    };
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting subjects information.');
    }
    Map assigMap = jsonDecode(utf8.decode(response.bodyBytes));
    return AssignaturaURL.fromJson(assigMap);
  }

  Future<AssignaturaGuia> getAssignaturaGuia(Assignatura assignatura) async {
    final locationUrl = assignatura.guia;
    if (locationUrl == null) {
      return null;
    }
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Accept-Language': lang,
      'Authorization': 'Bearer ' + accessToken
    };
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting subjects information.');
    }
    Map assigMap = jsonDecode(utf8.decode(response.bodyBytes));
    return AssignaturaGuia.fromJson(assigMap);
  }

  Future<Avisos> getAvisos() async {
    final locationUrl = '$baseUrl/jo/avisos';
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Accept-Language': lang,
      'Authorization': 'Bearer ' + accessToken
    };
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting notices information.');
    }
    Map avisosMap = jsonDecode(utf8.decode(response.bodyBytes));
    return Avisos.fromJson(avisosMap);
  }

  Future<Events> getEvents() async {
    final locationUrl = '$baseUrl/events';
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Accept-Language': lang,
      'Authorization': 'Bearer ' + accessToken
    };
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting events information.');
    }
    Map eventsMap = jsonDecode(utf8.decode(response.bodyBytes));
    return Events.fromJson(eventsMap);
  }

  Future<Noticies> getNoticies() async {
    final locationUrl = '$baseUrl/noticies';
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Accept-Language': lang,
      'Authorization': 'Bearer ' + accessToken
    };
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting news information.');
    }
    Map noticiesMap = jsonDecode(utf8.decode(response.bodyBytes));
    return Noticies.fromJson(noticiesMap);
  }

  Future<ExamensLaboratori> getExamsLaboratori() async {
    final locationUrl = '$baseUrl/examens-laboratori';
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Accept-Language': lang,
      'Authorization': 'Bearer ' + accessToken
    };
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting labs information.');
    }
    Map labExamsMap = jsonDecode(utf8.decode(response.bodyBytes));
    return ExamensLaboratori.fromJson(labExamsMap);
  }

  Future<Quadrimestre> getQuadrimestreActual() async {
    final locationUrl = '$baseUrl/quadrimestres/actual';
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Accept-Language': lang,
      'Authorization': 'Bearer ' + accessToken
    };
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting quadrimestres information.');
    }
    Map quadrimestreMap = jsonDecode(utf8.decode(response.bodyBytes));
    return Quadrimestre.fromJson(quadrimestreMap);
  }

  Future<Examens> getExamens(Quadrimestre quadrimestre) async {
    final locationUrl = quadrimestre.examens;
    if (locationUrl == null) return null;
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Accept-Language': lang,
      'Authorization': 'Bearer ' + accessToken
    };
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting exams information.');
    }
    Map examensMap = jsonDecode(utf8.decode(response.bodyBytes));
    return Examens.fromJson(examensMap);
  }

  Future<String> downloadAndSaveFile(String name,String url, String mimeType) async {
    final locationUrl = url;
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + accessToken
    };
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    FileInfo fileInfo = await DefaultCacheManager()
        .downloadFile(locationUrl, authHeaders: headers);
    Io.File file = fileInfo.file;
    Io.File writted = new Io.File(localPath + '/' + name)
      ..writeAsBytes(file.readAsBytesSync(), flush: true);
    return writted.path;
  }
}
