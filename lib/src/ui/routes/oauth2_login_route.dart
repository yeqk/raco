import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:raco/src/resources/global_translations.dart';

class Oauth2LoginRoute extends StatelessWidget {
  final String url;

  Oauth2LoginRoute(this.url);
  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
        url: url,
        appBar: new AppBar(
          title: new Text(allTranslations.text('signin')),
        ));
  }
}
