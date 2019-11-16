// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignatures.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Assignatures _$AssignaturesFromJson(Map<String, dynamic> json) {
  return Assignatures(
    json['count'] as int,
    (json['results'] as List)
        ?.map((e) =>
            e == null ? null : Assignatura.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AssignaturesToJson(Assignatures instance) =>
    <String, dynamic>{
      'count': instance.count,
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };

Assignatura _$AssignaturaFromJson(Map<String, dynamic> json) {
  return Assignatura(
    json['id'] as String,
    json['url'] as String,
    json['guia'] as String,
    json['grup'] as String,
    json['sigles'] as String,
    json['codi_upc'] as String,
    json['semestre'] as String,
    json['credits'] as String,
    json['nom'] as String,
  );
}

Map<String, dynamic> _$AssignaturaToJson(Assignatura instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'guia': instance.guia,
      'grup': instance.grup,
      'sigles': instance.sigles,
      'codi_upc': instance.codiUPC,
      'semestre': instance.semestre,
      'credits': instance.credits,
      'nom': instance.nom,
    };
