import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:raco/src/models/db_helpers/event_helper.dart';

part 'events.g.dart';

@JsonSerializable(explicitToJson: true)
class Events {
  int count;
  List<Event> results;

  Events(this.count, this.results);

  factory Events.fromJson(Map<String, dynamic> json) =>
      _$EventsFromJson(json);

  Map<String, dynamic> toJson() => _$EventsToJson(this);
}

@JsonSerializable()
class Event {
  String nom;
  String inici;
  String fi;


  Event(this.nom, this.inici, this.fi);

  Event.fromEventHelper(EventHelper eventHelper) {
    this.nom = eventHelper.nom;
    this.inici = eventHelper.inici;
    this.fi = eventHelper.fi;
  }

  factory Event.fromJson(Map<String, dynamic> json) =>
      _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
