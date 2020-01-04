import 'package:json_annotation/json_annotation.dart';
import 'package:raco/src/models/db_helpers/custom_event_helper.dart';

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

  CustomEvent.fromCustomEventHelper(CustomEventHelper customEventHelper) {
    this.id = customEventHelper.id;
    this.title = customEventHelper.title;
    this.description = customEventHelper.description;
    this.inici = customEventHelper.inici;
    this.fi = customEventHelper.fi;
  }

  factory CustomEvent.fromJson(Map<String, dynamic> json) =>
      _$CustomEventFromJson(json);

  Map<String, dynamic> toJson() => _$CustomEventToJson(this);
}
