import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class LoginButtonPressedEvent extends LoginEvent {
  final BuildContext context;

  LoginButtonPressedEvent({@required this.context}) : super([context]);
  @override
  String toString() =>
      'LoginButtonPressedEvent';
}

class VisitButtonPressedEvent extends LoginEvent {

  @override
  String toString() =>
      'VisitButtonPressedEvent';
}