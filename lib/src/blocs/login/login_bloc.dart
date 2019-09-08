import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:raco/src/resources/oauth2_data.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/blocs/login/login.dart';
import 'package:raco/src/ui/routes/oauth2_login_route.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  LoginState get initialState => LoginInitialState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressedEvent) {
      yield LoginLoadingState();
      var grant = new oauth2.AuthorizationCodeGrant(
          Oauth2Data.identifier, Oauth2Data.authorizationEndpoint,
          Oauth2Data.tokenEndpoint,
          secret: Oauth2Data.secret);
      String url = grant.getAuthorizationUrl(Oauth2Data.redirectUrl).toString();
      Navigator.push(event.context,
          MaterialPageRoute(builder: (context) => Oauth2LoginRoute(url)));

      final flutterWebviewPlugin = new FlutterWebviewPlugin();
      flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged st) async {
        if (Uri.parse(st.url).host == Oauth2Data.redirectUrl.host) {
          flutterWebviewPlugin.close();
        }
      });
      flutterWebviewPlugin.onUrlChanged.listen((String changedUrl) async {
        if (Uri.parse(changedUrl).host == Oauth2Data.redirectUrl.host) {
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