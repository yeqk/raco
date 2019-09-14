import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:raco/src/resources/authentication_data.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/blocs/login/login.dart';
import 'package:raco/src/ui/routes/oauth2_login_route.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.authenticationBloc,
  })  :assert(authenticationBloc != null);

  LoginState get initialState => LoginInitialState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressedEvent) {
      yield LoginLoadingState();
      var grant = new oauth2.AuthorizationCodeGrant(
          AuthenticationData.identifier, Uri.parse(AuthenticationData.authorizationEndpoint),
          Uri.parse(AuthenticationData.tokenEndpoint),
          secret: AuthenticationData.secret);
      String url = grant.getAuthorizationUrl(Uri.parse(AuthenticationData.redirectUrl)).toString();
      Navigator.push(event.context,
          MaterialPageRoute(builder: (context) => Oauth2LoginRoute(url)));

      final flutterWebviewPlugin = new FlutterWebviewPlugin();
      flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged st) async {
        if (Uri.parse(st.url).host == Uri.parse(AuthenticationData.redirectUrl).host) {
          flutterWebviewPlugin.close();
        }
      });
      flutterWebviewPlugin.onUrlChanged.listen((String changedUrl) async {
        if (Uri.parse(changedUrl).host == Uri.parse(AuthenticationData.redirectUrl).host) {
          flutterWebviewPlugin.close();
          var client = await grant.handleAuthorizationResponse(Uri
              .parse(changedUrl)
              .queryParameters);
          authenticationBloc.dispatch(LoggedInEvent(credentials: client.credentials));
          Navigator.pop(event.context);
        }
      });

    }

    if (event is VisitButtonPressedEvent) {
      authenticationBloc.dispatch(LoggedAsVisitorEvent());
    }
  }
}