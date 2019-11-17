// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignatura_url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignaturaURL _$AssignaturaURLFromJson(Map<String, dynamic> json) {
  return AssignaturaURL(
    json['id'] as String,
    json['url'] as String,
    json['guia'] as String,
    (json['obligatorietats'] as List)
        ?.map((e) => e == null
            ? null
            : Obligatorietat.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['plans'] as List)?.map((e) => e as String)?.toList(),
    json['lang'] == null
        ? null
        : Lang.fromJson(json['lang'] as Map<String, dynamic>),
    (json['quadrimestres'] as List)?.map((e) => e as String)?.toList(),
    json['sigles'] as String,
    json['codi_upc'] as int,
    json['semestre'] as String,
    (json['credits'] as num)?.toDouble(),
    json['nom'] as String,
  );
}

Map<String, dynamic> _$AssignaturaURLToJson(AssignaturaURL instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'guia': instance.guia,
      'obligatorietats':
          instance.obligatorietats?.map((e) => e?.toJson())?.toList(),
      'plans': instance.plans,
      'lang': instance.lang?.toJson(),
      'quadrimestres': instance.quadrimestres,
      'sigles': instance.sigles,
      'codi_upc': instance.codiUPC,
      'semestre': instance.semestre,
      'credits': instance.credits,
      'nom': instance.nom,
    };

Obligatorietat _$ObligatorietatFromJson(Map<String, dynamic> json) {
  return Obligatorietat(
    json['codi_oblig'] as String,
    json['codi_especialitat'] as String,
    json['pla'] as String,
    json['nom_especialitat'] as String,
  );
}

Map<String, dynamic> _$ObligatorietatToJson(Obligatorietat instance) =>
    <String, dynamic>{
      'codi_oblig': instance.codiOblig,
      'codi_especialitat': instance.codiEspecialitat,
      'pla': instance.pla,
      'nom_especialitat': instance.nomEspecialitat,
    };

Lang _$LangFromJson(Map<String, dynamic> json) {
  return Lang(
    (json['Q1'] as List)?.map((e) => e as String)?.toList(),
    (json['Q2'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$LangToJson(Lang instance) => <String, dynamic>{
      'Q1': instance.q1,
      'Q2': instance.q2,
    };
