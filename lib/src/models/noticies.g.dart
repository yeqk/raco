// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noticies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Noticies _$NoticiesFromJson(Map<String, dynamic> json) {
  return Noticies(
    json['count'] as int,
    (json['results'] as List)
        ?.map((e) =>
            e == null ? null : Noticia.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$NoticiesToJson(Noticies instance) => <String, dynamic>{
      'count': instance.count,
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };

Noticia _$NoticiaFromJson(Map<String, dynamic> json) {
  return Noticia(
    json['titol'] as String,
    json['link'] as String,
    json['descripcio'] as String,
    json['data_publicacio'] as String,
  );
}

Map<String, dynamic> _$NoticiaToJson(Noticia instance) => <String, dynamic>{
      'titol': instance.titol,
      'link': instance.link,
      'descripcio': instance.descripcio,
      'data_publicacio': instance.dataPublicacio,
    };
