import 'package:json_annotation/json_annotation.dart';

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

  factory Event.fromJson(Map<String, dynamic> json) =>
      _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
