// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'examens.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Examens _$ExamensFromJson(Map<String, dynamic> json) {
  return Examens(
    json['count'] as int,
    (json['results'] as List)
        ?.map((e) =>
            e == null ? null : Examen.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ExamensToJson(Examens instance) => <String, dynamic>{
      'count': instance.count,
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };

Examen _$ExamenFromJson(Map<String, dynamic> json) {
  return Examen(
    json['id'] as int,
    json['assig'] as String,
    json['aules'] as String,
    json['inici'] as String,
    json['fi'] as String,
    json['quatr'] as int,
    json['curs'] as int,
    json['pla'] as String,
    json['tipus'] as String,
    json['comentaris'] as String,
    json['eslaboratori'] as String,
  );
}

Map<String, dynamic> _$ExamenToJson(Examen instance) => <String, dynamic>{
      'id': instance.id,
      'assig': instance.assig,
      'aules': instance.aules,
      'inici': instance.inici,
      'fi': instance.fi,
      'quatr': instance.quatr,
      'curs': instance.curs,
      'pla': instance.pla,
      'tipus': instance.tipus,
      'comentaris': instance.comentaris,
      'eslaboratori': instance.eslaboratori,
    };
