// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignatura_guia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignaturaGuia _$AssignaturaGuiaFromJson(Map<String, dynamic> json) {
  return AssignaturaGuia(
    json['id'] as String,
    json['competencies'] as String,
    json['hores'] == null
        ? null
        : Hores.fromJson(json['hores'] as Map<String, dynamic>),
    (json['objectius'] as List)
        ?.map((e) =>
            e == null ? null : Objectiu.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['continguts'] as List)
        ?.map((e) =>
            e == null ? null : Contingut.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['activitats'] as List)
        ?.map((e) =>
            e == null ? null : Activitat.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['actes_avaluatius'] as List)
        ?.map((e) => e == null
            ? null
            : ActeAvaluatiu.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['professors'] as List)
        ?.map((e) =>
            e == null ? null : Professor.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['urls'] as List)?.map((e) => e as String)?.toList(),
    json['bibliografia'] == null
        ? null
        : Bibliografia.fromJson(json['bibliografia'] as Map<String, dynamic>),
    (json['ordre_activitats'] as List)?.map((e) => e as int)?.toList(),
    (json['credits'] as num)?.toDouble(),
    json['mail'] as String,
    json['web'] as String,
    json['departament'] as String,
    json['nom'] as String,
    json['descripcio'] as String,
    json['metodologia_docent'] as String,
    json['metodologia_avaluacio'] as String,
    json['capacitats_previes'] as String,
  );
}

Map<String, dynamic> _$AssignaturaGuiaToJson(AssignaturaGuia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'competencies': instance.competencies,
      'hores': instance.hores?.toJson(),
      'objectius': instance.objectius?.map((e) => e?.toJson())?.toList(),
      'continguts': instance.continguts?.map((e) => e?.toJson())?.toList(),
      'activitats': instance.activitats?.map((e) => e?.toJson())?.toList(),
      'actes_avaluatius':
          instance.actesAvaluatius?.map((e) => e?.toJson())?.toList(),
      'professors': instance.professors?.map((e) => e?.toJson())?.toList(),
      'urls': instance.urls,
      'bibliografia': instance.bibliografia?.toJson(),
      'ordre_activitats': instance.ordreActivitats,
      'credits': instance.credits,
      'mail': instance.mail,
      'web': instance.web,
      'departament': instance.departament,
      'nom': instance.nom,
      'descripcio': instance.descripcio,
      'metodologia_docent': instance.metodologiaDocent,
      'metodologia_avaluacio': instance.metodologiaAvaluacio,
      'capacitats_previes': instance.capacitatsPrevies,
    };

Hores _$HoresFromJson(Map<String, dynamic> json) {
  return Hores(
    (json['aprenentatge_autonom'] as num)?.toDouble(),
    (json['aprenentatge_dirigit'] as num)?.toDouble(),
    (json['laboratori'] as num)?.toDouble(),
    (json['problemes'] as num)?.toDouble(),
    (json['teoria'] as num)?.toDouble(),
    (json['addicional'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$HoresToJson(Hores instance) => <String, dynamic>{
      'aprenentatge_autonom': instance.aprenentatgeAutonom,
      'aprenentatge_dirigit': instance.aprenentatgeDirigit,
      'laboratori': instance.laboratori,
      'problemes': instance.problemes,
      'teoria': instance.teoria,
      'addicional': instance.addicional,
    };

Objectiu _$ObjectiuFromJson(Map<String, dynamic> json) {
  return Objectiu(
    json['id'] as int,
    (json['competencies'] as List)?.map((e) => e as String)?.toList(),
    (json['subobjectius'] as List)?.map((e) => e as String)?.toList(),
    json['valor'] as String,
  );
}

Map<String, dynamic> _$ObjectiuToJson(Objectiu instance) => <String, dynamic>{
      'id': instance.id,
      'competencies': instance.competencies,
      'subobjectius': instance.subobjectius,
      'valor': instance.valor,
    };

Contingut _$ContingutFromJson(Map<String, dynamic> json) {
  return Contingut(
    json['id'] as int,
    json['nom'] as String,
    json['descripcio'] as String,
  );
}

Map<String, dynamic> _$ContingutToJson(Contingut instance) => <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'descripcio': instance.descripcio,
    };

Activitat _$ActivitatFromJson(Map<String, dynamic> json) {
  return Activitat(
    json['id'] as int,
    json['teoria'] == null
        ? null
        : Teoria.fromJson(json['teoria'] as Map<String, dynamic>),
    json['laboratori'] == null
        ? null
        : Laboratori.fromJson(json['laboratori'] as Map<String, dynamic>),
    json['aprenentatge_autonom'] == null
        ? null
        : AprenentatgeAutonom.fromJson(
            json['aprenentatge_autonom'] as Map<String, dynamic>),
    json['aprenentatge_dirigit'] == null
        ? null
        : AprenentatgeDirigit.fromJson(
            json['aprenentatge_dirigit'] as Map<String, dynamic>),
    json['problemes'] == null
        ? null
        : Problemes.fromJson(json['problemes'] as Map<String, dynamic>),
    (json['continguts'] as List)?.map((e) => e as int)?.toList(),
    (json['objectius'] as List)?.map((e) => (e as num)?.toDouble())?.toList(),
    json['nom'] as String,
    json['descripcio'] as String,
  );
}

Map<String, dynamic> _$ActivitatToJson(Activitat instance) => <String, dynamic>{
      'id': instance.id,
      'teoria': instance.teoria?.toJson(),
      'laboratori': instance.laboratori?.toJson(),
      'aprenentatge_autonom': instance.aprenentatgeAutonom?.toJson(),
      'aprenentatge_dirigit': instance.aprenentatgeDirigit?.toJson(),
      'problemes': instance.problemes?.toJson(),
      'continguts': instance.continguts,
      'objectius': instance.objectius,
      'nom': instance.nom,
      'descripcio': instance.descripcio,
    };

Teoria _$TeoriaFromJson(Map<String, dynamic> json) {
  return Teoria(
    (json['hores'] as num)?.toDouble(),
    json['descripcio'] as String,
  );
}

Map<String, dynamic> _$TeoriaToJson(Teoria instance) => <String, dynamic>{
      'hores': instance.hores,
      'descripcio': instance.descripcio,
    };

Laboratori _$LaboratoriFromJson(Map<String, dynamic> json) {
  return Laboratori(
    (json['hores'] as num)?.toDouble(),
    json['descripcio'] as String,
  );
}

Map<String, dynamic> _$LaboratoriToJson(Laboratori instance) =>
    <String, dynamic>{
      'hores': instance.hores,
      'descripcio': instance.descripcio,
    };

AprenentatgeAutonom _$AprenentatgeAutonomFromJson(Map<String, dynamic> json) {
  return AprenentatgeAutonom(
    (json['hores'] as num)?.toDouble(),
    json['descripcio'] as String,
  );
}

Map<String, dynamic> _$AprenentatgeAutonomToJson(
        AprenentatgeAutonom instance) =>
    <String, dynamic>{
      'hores': instance.hores,
      'descripcio': instance.descripcio,
    };

AprenentatgeDirigit _$AprenentatgeDirigitFromJson(Map<String, dynamic> json) {
  return AprenentatgeDirigit(
    (json['hores'] as num)?.toDouble(),
    json['descripcio'] as String,
  );
}

Map<String, dynamic> _$AprenentatgeDirigitToJson(
        AprenentatgeDirigit instance) =>
    <String, dynamic>{
      'hores': instance.hores,
      'descripcio': instance.descripcio,
    };

Problemes _$ProblemesFromJson(Map<String, dynamic> json) {
  return Problemes(
    (json['hores'] as num)?.toDouble(),
    json['descripcio'] as String,
  );
}

Map<String, dynamic> _$ProblemesToJson(Problemes instance) => <String, dynamic>{
      'hores': instance.hores,
      'descripcio': instance.descripcio,
    };

ActeAvaluatiu _$ActeAvaluatiuFromJson(Map<String, dynamic> json) {
  return ActeAvaluatiu(
    json['id'] as int,
    json['fora_horaris'] as bool,
    (json['objectius'] as List)?.map((e) => e as int)?.toList(),
    json['setmana'] as int,
    json['tipus'] as String,
    json['hores_duracio'] as int,
    json['hores_estudi'] as int,
    json['data'] as String,
    json['nom'] as String,
    json['descripcio'] as String,
  );
}

Map<String, dynamic> _$ActeAvaluatiuToJson(ActeAvaluatiu instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fora_horaris': instance.foraHoraris,
      'objectius': instance.objectius,
      'setmana': instance.setmana,
      'tipus': instance.tipus,
      'hores_duracio': instance.horesDuracio,
      'hores_estudi': instance.horesEstudi,
      'data': instance.data,
      'nom': instance.nom,
      'descripcio': instance.descripcio,
    };

Professor _$ProfessorFromJson(Map<String, dynamic> json) {
  return Professor(
    json['nom'] as String,
    json['email'] as String,
    json['is_responsable'] as bool,
  );
}

Map<String, dynamic> _$ProfessorToJson(Professor instance) => <String, dynamic>{
      'nom': instance.nom,
      'email': instance.email,
      'is_responsable': instance.isResponsable,
    };

Bibliografia _$BibliografiaFromJson(Map<String, dynamic> json) {
  return Bibliografia(
    (json['basica'] as List)
        ?.map((e) =>
            e == null ? null : Biblio.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['complementaria'] as List)
        ?.map((e) =>
            e == null ? null : Biblio.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BibliografiaToJson(Bibliografia instance) =>
    <String, dynamic>{
      'basica': instance.basica?.map((e) => e?.toJson())?.toList(),
      'complementaria':
          instance.complementaria?.map((e) => e?.toJson())?.toList(),
    };

Biblio _$BiblioFromJson(Map<String, dynamic> json) {
  return Biblio(
    json['id'] as int,
    json['titol'] as String,
    json['autor'] as String,
    json['editorial'] as String,
    json['any_bib'] as String,
    json['disponible_biblioteca'] as bool,
    json['edicio'] as String,
    json['isbn'] as String,
    json['url'] as String,
  );
}

Map<String, dynamic> _$BiblioToJson(Biblio instance) => <String, dynamic>{
      'id': instance.id,
      'titol': instance.titol,
      'autor': instance.autor,
      'editorial': instance.editorial,
      'any_bib': instance.anyBib,
      'disponible_biblioteca': instance.disponibleBiblioteca,
      'edicio': instance.edicio,
      'isbn': instance.isbn,
      'url': instance.url,
    };
