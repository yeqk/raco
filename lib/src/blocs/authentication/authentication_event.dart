import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:oauth2/oauth2.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class AppStartedEvent extends AuthenticationEvent {
  @override
  String toString() => 'AppStartedEvent';
}

class LoggedInEvent extends AuthenticationEvent {
  final Credentials credentials;

  LoggedInEvent({@required this.credentials}) : super([credentials]);

  @override
  String toString() =>
      'LoggedInEvent { credentials: ' + credentials.toJson() + ' }';
}

class LoggedOutEvent extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOutEvent';
}

class LoggedAsVisitorEvent extends AuthenticationEvent {
  @override
  String toString() => 'LoggedAsVisitorEvent';
}
