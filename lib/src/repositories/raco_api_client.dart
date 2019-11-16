import 'dart:convert';
import 'dart:async';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;
import 'package:image/image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raco/src/models/assignatures.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/models/me.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/utils/file_names.dart';

class RacoApiClient {
  static const baseUrl = 'https://api.fib.upc.edu/v2';
  final http.Client httpClient;


  RacoApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<Me> getMe(String accessToken, String lang) async {
    final locationUrl = '$baseUrl/jo';
    Map<String, String> headers = {'Accept' : 'application/json', 'Accept-Language' : lang, 'Authorization' : 'Bearer ' + accessToken};
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting me information.');
    }
    Map meMap = jsonDecode(utf8.decode(response.bodyBytes));
    return Me.fromJson(meMap);
  }

  Future<String> getImage(String accessToken, String lang) async {
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

  Future<Classes> getClasses(String accessToken, String lang) async {
    final locationUrl = '$baseUrl/jo/classes';
    Map<String, String> headers = {'Accept' : 'application/json', 'Accept-Language' : lang, 'Authorization' : 'Bearer ' + accessToken};
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting me information.');
    }
    Map classesMap = jsonDecode(response.body);
    return Classes.fromJson(classesMap);
  }

  Future<Assignatures> getAssignatures(String accessToken, String lang) async {
    final locationUrl = '$baseUrl/jo/assignatures';
    Map<String, String> headers = {'Accept' : 'application/json', 'Accept-Language' : lang, 'Authorization' : 'Bearer ' + accessToken};
    final response = await this.httpClient.get(locationUrl, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error getting me information.');
    }
    Map assigMap = jsonDecode(response.body);
    return Assignatures.fromJson(assigMap);
  }
}
