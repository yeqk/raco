import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/models/custom_grades.dart';
import 'package:raco/src/ui/routes/bottom_navigation/events_route.dart';

abstract class GradesEvent extends Equatable {
  GradesEvent([List props = const []]) : super(props);
}

class GradesInitEvent extends GradesEvent {

  GradesInitEvent();
  @override
  String toString() =>
      'GradesInitEvent';
}

class GradesDeleteEvent extends GradesEvent {
  final CustomGrade customGrade;
  GradesDeleteEvent({@required this.customGrade}) : super([customGrade]);
  @override
  String toString() =>
      'GradesDeleteEvent';
}

class GradesEditEvent extends GradesEvent {

  GradesEditEvent();
  @override
  String toString() =>
      'GradesEditEvent';
}

class GradesAddEvent extends GradesEvent {
  final CustomGrade customGrade;
  GradesAddEvent({@required this.customGrade}) : super([customGrade]);
  @override
  String toString() =>
      'GradesEditEvent';
}

