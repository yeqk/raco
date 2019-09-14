import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository = UserRepository.instance;

  @override
  AuthenticationState get initialState => AuthenticationUninitializedState();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AppStartedEvent) {
      final bool hasCredentials = await userRepository.hasCredentials();
      final bool isVisitor = await userRepository.isLoggedAsVisitor();
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
      await userRepository.persistCredentials(event.credentials);
      yield AuthenticationAuthenticatedState();
    }

    if (event is LoggedOutEvent) {
      yield AuthenticationLoadingState();
      await userRepository.deleteCredentials();
      yield AuthenticationUnauthenticatedState();
    }

    if (event is LoggedAsVisitorEvent) {
      yield AuthenticationLoadingState();
      await userRepository.setLoggedAsVisitor();
      yield AuthenticationVisitorLoggedState();
    }

  }
}