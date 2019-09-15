import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class AuthenticationUninitializedState extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUninitializedState';
}

class AuthenticationAuthenticatedState extends AuthenticationState {
  @override
  String toString() => 'AuthenticationAuthenticatedState';
}

class AuthenticationUnauthenticatedState extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUnauthenticatedState';
}

class AuthenticationLoadingState extends AuthenticationState {
  @override
  String toString() => 'AuthenticationLoadingState';
}

class AuthenticationVisitorLoggedState extends AuthenticationState {
  @override
  String toString() => 'AuthenticationVisitorLoggedState';
}
