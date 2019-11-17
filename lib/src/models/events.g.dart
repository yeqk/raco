// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Events _$EventsFromJson(Map<String, dynamic> json) {
  return Events(
    json['count'] as int,
    (json['results'] as List)
        ?.map(
            (e) => e == null ? null : Event.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$EventsToJson(Events instance) => <String, dynamic>{
      'count': instance.count,
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    json['nom'] as String,
    json['inici'] as String,
    json['fi'] as String,
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'nom': instance.nom,
      'inici': instance.inici,
      'fi': instance.fi,
    };
