import 'package:json_annotation/json_annotation.dart';

part 'custom_events.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomEvents {
  int count;
  List<CustomEvent> results;

  CustomEvents(this.count, this.results);

  factory CustomEvents.fromJson(Map<String, dynamic> json) =>
      _$CustomEventsFromJson(json);

  Map<String, dynamic> toJson() => _$CustomEventsToJson(this);
}

@JsonSerializable()
class CustomEvent {
  String id;
  String title;
  String description;
  String inici;
  String fi;


  CustomEvent(this.id, this.title, this.description, this.inici, this.fi);

  factory CustomEvent.fromJson(Map<String, dynamic> json) =>
      _$CustomEventFromJson(json);

  Map<String, dynamic> toJson() => _$CustomEventToJson(this);
}
