// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avisos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Avisos _$AvisosFromJson(Map<String, dynamic> json) {
  return Avisos(
    json['count'] as int,
    (json['results'] as List)
        ?.map(
            (e) => e == null ? null : Avis.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AvisosToJson(Avisos instance) => <String, dynamic>{
      'count': instance.count,
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };

Avis _$AvisFromJson(Map<String, dynamic> json) {
  return Avis(
    json['id'] as int,
    json['titol'] as String,
    json['codi_assig'] as String,
    json['text'] as String,
    json['data_insercio'] as String,
    json['data_modificacio'] as String,
    (json['adjunts'] as List)
        ?.map((e) =>
            e == null ? null : Adjunt.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..dataCaducitat = json['data_caducitat'] as String;
}

Map<String, dynamic> _$AvisToJson(Avis instance) => <String, dynamic>{
      'id': instance.id,
      'titol': instance.titol,
      'codi_assig': instance.codiAssig,
      'text': instance.text,
      'data_insercio': instance.dataInsercio,
      'data_modificacio': instance.dataModificacio,
      'data_caducitat': instance.dataCaducitat,
      'adjunts': instance.adjunts?.map((e) => e?.toJson())?.toList(),
    };

Adjunt _$AdjuntFromJson(Map<String, dynamic> json) {
  return Adjunt(
    json['tipus_mime'] as String,
    json['nom'] as String,
    json['url'] as String,
    json['data_modificacio'] as String,
    json['mida'] as int,
  );
}

Map<String, dynamic> _$AdjuntToJson(Adjunt instance) => <String, dynamic>{
      'tipus_mime': instance.tipusMime,
      'nom': instance.nom,
      'url': instance.url,
      'data_modificacio': instance.dataModificacio,
      'mida': instance.mida,
    };
