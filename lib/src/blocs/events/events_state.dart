import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class EventsState extends Equatable {
  EventsState([List props = const []]) : super(props);
}

class EventsInitState extends EventsState {

  @override
  String toString() => 'EventsInitState';
}

class UpdateEventsSuccessfullyState extends EventsState {

  @override
  String toString() => 'UpdateEventsSuccessfullyState';
}

class UpdateEventsErrorState extends EventsState {
  @override
  String toString() => 'UpdateEventsErrorState';
}

class UpdateEventsTooFrequentlyState extends EventsState {
  @override
  String toString() => 'UpdateEventsTooFrequentlyState';
}

class EventDeletedState extends EventsState {
  @override
  String toString() => 'EventDeletedState';
}

class EventEditedState extends EventsState {
  @override
  String toString() => 'EventEditedState';
}

class EventAddedState extends EventsState {
  @override
  String toString() => 'EventAddedState';
}

