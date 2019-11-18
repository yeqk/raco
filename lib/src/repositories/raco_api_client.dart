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


  RacoApiClient({
    @required this.httpClient, @required this.accessToken, @required this.lang
  }) : assert(httpClient != null && accessToken != null && lang != null);

  Future<Me> getMe() async {
    final locationUrl = '$baseUrl/jo';
    Map<String, String> headers = {'Accept' : 'application/json', 'Accept-Language' : lang, 'Authorization' : 'Bearer ' + accessToken};
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting me information.');
    }
    Map meMap = jsonDecode(utf8.decode(response.bodyBytes));
    return Me.fromJson(meMap);
  }

  Future<String> getImage() async {
    final locationUrl = '$baseUrl/jo/foto.jpg';
    Map<String, String> headers = {'Authorization' : 'Bearer ' + accessToken};
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    FileInfo fileInfo =  await DefaultCacheManager().downloadFile(locationUrl, authHeaders: headers);
    Io.File file = fileInfo.file;
    Image image = decodeImage(file.readAsBytesSync());
    Io.File imgFile = new Io.File(localPath + '/' + FileNames.AVATAR)
      ..writeAsBytesSync(encodeJpg(image), flush: true);
    return imgFile.path;
  }

  Future<String> getImageA5() async {
    final locationUrl = '$baseUrl/laboratoris/imatges/A5.png';
    Map<String, String> headers = {'Authorization' : 'Bearer ' + accessToken};
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    FileInfo fileInfo =  await DefaultCacheManager().downloadFile(locationUrl, authHeaders: headers);
    Io.File file = fileInfo.file;
    Image image = decodeImage(file.readAsBytesSync());
    Io.File imgFile = new Io.File(localPath + '/' + FileNames.A5)
      ..writeAsBytesSync(encodePng(image), flush: true);
    return imgFile.path;
  }

  Future<String> getImageC6() async {
    final locationUrl = '$baseUrl/laboratoris/imatges/C6.png';
    Map<String, String> headers = {'Authorization' : 'Bearer ' + accessToken};
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    FileInfo fileInfo =  await DefaultCacheManager().downloadFile(locationUrl, authHeaders: headers);
    Io.File file = fileInfo.file;
    Image image = decodeImage(file.readAsBytesSync());
    Io.File imgFile = new Io.File(localPath + '/' + FileNames.C6)
      ..writeAsBytesSync(encodePng(image), flush: true);
    return imgFile.path;
  }

  Future<String> getImageB5() async {
    final locationUrl = '$baseUrl/laboratoris/imatges/B5.png';
    Map<String, String> headers = {'Authorization' : 'Bearer ' + accessToken};
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    FileInfo fileInfo =  await DefaultCacheManager().downloadFile(locationUrl, authHeaders: headers);
    Io.File file = fileInfo.file;
    Image image = decodeImage(file.readAsBytesSync());
    Io.File imgFile = new Io.File(localPath + '/' + FileNames.B5)
      ..writeAsBytesSync(encodePng(image), flush: true);
    return imgFile.path;
  }
  Future<Classes> getClasses() async {
    final locationUrl = '$baseUrl/jo/classes';
    Map<String, String> headers = {'Accept' : 'application/json', 'Accept-Language' : lang, 'Authorization' : 'Bearer ' + accessToken};
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting me information.');
    }
    Map classesMap = jsonDecode(response.body);
    return Classes.fromJson(classesMap);
  }

  Future<Assignatures> getAssignatures() async {
    final locationUrl = '$baseUrl/jo/assignatures';
    Map<String, String> headers = {'Accept' : 'application/json', 'Accept-Language' : lang, 'Authorization' : 'Bearer ' + accessToken};
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting me information.');
    }
    Map assigMap = jsonDecode(response.body);
    return Assignatures.fromJson(assigMap);
  }

  Future<Avisos> getAvisos() async {
    final locationUrl = '$baseUrl/jo/avisos';
    Map<String, String> headers = {'Accept' : 'application/json', 'Accept-Language' : lang, 'Authorization' : 'Bearer ' + accessToken};
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting me information.');
    }
    Map avisosMap = jsonDecode(response.body);
    return Avisos.fromJson(avisosMap);
  }

  Future<Events> getEvents() async {
    final locationUrl = '$baseUrl/events';
    Map<String, String> headers = {'Accept' : 'application/json', 'Accept-Language' : lang, 'Authorization' : 'Bearer ' + accessToken};
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting me information.');
    }
    Map eventsMap = jsonDecode(response.body);
    return Events.fromJson(eventsMap);
  }

  Future<Noticies> getNoticies() async {
    final locationUrl = '$baseUrl/noticies';
    Map<String, String> headers = {'Accept' : 'application/json', 'Accept-Language' : lang, 'Authorization' : 'Bearer ' + accessToken};
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting me information.');
    }
    Map noticiesMap = jsonDecode(response.body);
    return Noticies.fromJson(noticiesMap);
  }

  Future<ExamensLaboratori> getExamsLaboratori() async {
    final locationUrl = '$baseUrl/examens-laboratori';
    Map<String, String> headers = {'Accept' : 'application/json', 'Accept-Language' : lang, 'Authorization' : 'Bearer ' + accessToken};
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting me information.');
    }
    Map labExamsMap = jsonDecode(response.body);
    return ExamensLaboratori.fromJson(labExamsMap);
  }

  Future<Quadrimestre> getQuadrimestreActual() async {
    final locationUrl = '$baseUrl/quadrimestres/actual';
    Map<String, String> headers = {'Accept' : 'application/json', 'Accept-Language' : lang, 'Authorization' : 'Bearer ' + accessToken};
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting me information.');
    }
    Map quadrimestreMap = jsonDecode(response.body);
    return Quadrimestre.fromJson(quadrimestreMap);
  }

  Future<Examens> getExamens(Quadrimestre quadrimestre) async {
    final locationUrl = quadrimestre.examens;
    Map<String, String> headers = {'Accept' : 'application/json', 'Accept-Language' : lang, 'Authorization' : 'Bearer ' + accessToken};
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting me information.');
    }
    Map examensMap = jsonDecode(response.body);
    return Examens.fromJson(examensMap);
  }
}
