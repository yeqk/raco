import 'dart:async';
import 'package:meta/meta.dart';
import 'package:raco/src/models/models.dart';
import 'raco_api_client.dart';

class RacoRepository {
  final RacoApiClient racoApiClient;

  RacoRepository({@required this.racoApiClient})
      : assert(racoApiClient != null);

  Future<Me> getMe(String accessToken, String lang) async {
    return await racoApiClient.getMe(accessToken, lang);
  }

  Future<String> getImage(String accessToken, String lang) async {
    return await racoApiClient.getImage(accessToken, lang);
  }
}