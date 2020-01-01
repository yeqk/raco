import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:raco/src/ui/routes/bottom_navigation/events_route.dart';

abstract class EventsEvent extends Equatable {
  EventsEvent([List props = const []]) : super(props);
}

class EventsInitEvent extends EventsEvent {

  EventsInitEvent();
  @override
  String toString() =>
      'EventsInitEvent';
}


class EventsChangedEvent extends EventsEvent {

  EventsChangedEvent();
  @override
  String toString() =>
      'EventsChangedEvent';
}

class EventsDeleteEvent extends EventsEvent {
  EventItem item;
  EventsDeleteEvent({@required this.item}) : super([item]);
  @override
  String toString() =>
      'EventsDeleteEvent';
}
