// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'examens_laboratori.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamensLaboratori _$ExamensLaboratoriFromJson(Map<String, dynamic> json) {
  return ExamensLaboratori(
    json['propers_examens_laboratori'] as String,
    json['count'] as int,
    (json['results'] as List)
        ?.map((e) => e == null
            ? null
            : ExamenLaboratori.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ExamensLaboratoriToJson(ExamensLaboratori instance) =>
    <String, dynamic>{
      'propers_examens_laboratori': instance.propersExamensLaboratori,
      'count': instance.count,
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };

ExamenLaboratori _$ExamenLaboratoriFromJson(Map<String, dynamic> json) {
  return ExamenLaboratori(
    json['id'] as String,
    json['description'] as String,
    json['title'] as String,
    json['assig'] as String,
    json['aules'] as String,
    json['inici'] as String,
    json['fi'] as String,
    json['comentaris'] as String,
    json['entorn_segur'] as String,
    json['usb_disponible'] as String,
    json['imatge'] as String,
    json['tipus_usuari'] as String,
    json['acces_url'] as String,
    json['acces_home_dades'] as String,
    json['observacions_necessitats'] as String,
  );
}

Map<String, dynamic> _$ExamenLaboratoriToJson(ExamenLaboratori instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'title': instance.title,
      'assig': instance.assig,
      'aules': instance.aules,
      'inici': instance.inici,
      'fi': instance.fi,
      'comentaris': instance.comentaris,
      'entorn_segur': instance.entornSegur,
      'usb_disponible': instance.usbDisponible,
      'imatge': instance.imatge,
      'tipus_usuari': instance.tipusUsuari,
      'acces_url': instance.accessURL,
      'acces_home_dades': instance.accesHomeDades,
      'observacions_necessitats': instance.observacionsNecessitats,
    };
