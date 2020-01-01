import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/models/custom_grades.dart';
import 'package:raco/src/ui/routes/bottom_navigation/events_route.dart';

abstract class ConfigurationEvent extends Equatable {
  ConfigurationEvent([List props = const []]) : super(props);
}

class ChangePrimaryColorEvent extends ConfigurationEvent {
  final String colorCode;
  ChangePrimaryColorEvent({@required this.colorCode}) : super([colorCode]);
  @override
  String toString() =>
      'ChangePrimaryColorEvent';
}

class ChangeSecondaryColorEvent extends ConfigurationEvent {
  final String colorCode;
  ChangeSecondaryColorEvent({@required this.colorCode}) : super([colorCode]);
  @override
  String toString() =>
      'ChangeSecondaryColorEvent';
}

class ChangeSubjectColorEvent extends ConfigurationEvent {
  final String colorCode;
  final String subject;
  ChangeSubjectColorEvent({@required this.colorCode, @required this.subject}) : super([colorCode,subject]);
  @override
  String toString() =>
      'ChangeSubjectColorEvent';
}
