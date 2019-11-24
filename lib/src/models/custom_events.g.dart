// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomEvents _$CustomEventsFromJson(Map<String, dynamic> json) {
  return CustomEvents(
    json['count'] as int,
    (json['results'] as List)
        ?.map((e) =>
            e == null ? null : CustomEvent.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CustomEventsToJson(CustomEvents instance) =>
    <String, dynamic>{
      'count': instance.count,
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };

CustomEvent _$CustomEventFromJson(Map<String, dynamic> json) {
  return CustomEvent(
    json['title'] as String,
    json['description'] as String,
    json['inici'] as String,
    json['fi'] as String,
  );
}

Map<String, dynamic> _$CustomEventToJson(CustomEvent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'inici': instance.inici,
      'fi': instance.fi,
    };
