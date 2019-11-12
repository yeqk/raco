import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/repositories/repositories.dart';
import 'package:http/http.dart' as http;
import 'package:raco/src/models/models.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

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
        yield AuthenticationAuthenticatedState();
      } else {
        if (isVisitor) {
          yield AuthenticationVisitorLoggedState();
        }
        else {
          yield AuthenticationUnauthenticatedState();
        }
      }

    }

    if (event is LoggedInEvent) {
      yield AuthenticationLoadingState();
      await user.persistCredentials(event.credentials);
      RacoRepository rr = new RacoRepository(racoApiClient: RacoApiClient(
        httpClient: http.Client(),
      ));
      print("GGGGGGGGGGEEEEEEEEEEEEEEETTTT");
      String accessToken = await user.getAccessToken();
      String lang = await user.getPreferredLanguage();
      Me me = await rr.getMe(accessToken, lang);
      print("CAACACA");
      await rr.getImage(accessToken, lang);
      Dme dme = Dme();
      dme.username = me.username;
      dme.nom = me.nom;
      dme.cognoms = me.cognoms;
      dme.email = me.email;
      await user.writeToPreferences('me', jsonEncode(me));
      yield AuthenticationAuthenticatedState();
    }

    if (event is LoggedOutEvent) {
      yield AuthenticationLoadingState();
      if (await user.isLoggedAsVisitor()) {
        await user.deleteVisitor();
      }
      if (await user.hasCredentials()) {
        await user.deleteCredentials();
      }
      yield AuthenticationUnauthenticatedState();
    }

    if (event is LoggedAsVisitorEvent) {
      yield AuthenticationLoadingState();
      await user.setLoggedAsVisitor();
      yield AuthenticationVisitorLoggedState();
    }

  }
}