import 'dart:convert';
import 'dart:async';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:raco/src/models/me.dart';
import 'package:raco/src/resources/user_repository.dart';

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
    Map meMap = jsonDecode(response.body);
    return Me.fromJson(meMap);
  }

  Future<void> getImage(String accessToken, String lang) async {
    final locationUrl = '$baseUrl/jo/foto.jpg';
    Map<String, String> headers = {'Accept' : 'image/apng', 'Accept-Language' : lang, 'Authorization' : 'Bearer ' + accessToken};
    final response = await this.httpClient.get(locationUrl, headers: headers);
    print("IMMMMMMMMMMMA: " + response.body);
  }
}
