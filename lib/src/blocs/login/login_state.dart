import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super(props);
}

class LoginInitialState extends LoginState {
  @override
  String toString() => 'LoginInitial';
}

class LoginRedirectUrlGeneratedState extends LoginState {
  final String url;

  LoginRedirectUrlGeneratedState({@required this.url}) : super([url]);
  @override
  String toString() => 'LoginRedirectUriGeneratedState';
}

class LoginSucessfullyState extends LoginState {

  @override
  String toString() => 'LoginSuccessfullyState';
}

class LoginLoadingState extends LoginState {
  @override
  String toString() => 'LoginLoadingState';
}