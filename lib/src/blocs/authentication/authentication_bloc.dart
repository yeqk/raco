import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository}): assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitializedState();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AppStartedEvent) {
      final bool hasCredentails = await userRepository.hasCredentials();
      if (hasCredentails) {
        yield AuthenticationAuthenticatedState();
      } else {
        yield AuthenticationUnauthenticatedState();
      }

      final bool isVisitor = await userRepository.isLoggedAsVisitor();
      if (isVisitor) {
        yield AuthenticationVisitorLoggedState();
      } else {
        yield AuthenticationUnauthenticatedState();
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