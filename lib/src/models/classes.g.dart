// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Classes _$ClassesFromJson(Map<String, dynamic> json) {
  return Classes(
    json['count'] as int,
    (json['results'] as List)
        ?.map((e) =>
            e == null ? null : Classe.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ClassesToJson(Classes instance) => <String, dynamic>{
      'count': instance.count,
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };

Classe _$ClasseFromJson(Map<String, dynamic> json) {
  return Classe(
    json['codi_assig'] as String,
    json['grup'] as String,
    json['dia_setmana'] as int,
    json['inici'] as String,
    json['durada'] as int,
    json['tipus'] as String,
    json['aules'] as String,
  );
}

Map<String, dynamic> _$ClasseToJson(Classe instance) => <String, dynamic>{
      'codi_assig': instance.codiAssig,
      'grup': instance.grup,
      'dia_setmana': instance.diaSetmana,
      'inici': instance.inici,
      'durada': instance.durada,
      'tipus': instance.tipus,
      'aules': instance.aules,
    };
