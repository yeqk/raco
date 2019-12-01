// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requisits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Requisits _$RequisitsFromJson(Map<String, dynamic> json) {
  return Requisits(
    json['count'] as int,
    (json['results'] as List)
        ?.map((e) =>
            e == null ? null : Requisit.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$RequisitsToJson(Requisits instance) => <String, dynamic>{
      'count': instance.count,
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };

Requisit _$RequisitFromJson(Map<String, dynamic> json) {
  return Requisit(
    json['origin'] as String,
    json['destination'] as String,
    json['tipus'] as String,
  );
}

Map<String, dynamic> _$RequisitToJson(Requisit instance) => <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
      'tipus': instance.tipus,
    };
