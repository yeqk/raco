// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Me _$MeFromJson(Map<String, dynamic> json) {
  return Me(
    json['assignatures'] as String,
    json['avisos'] as String,
    json['classes'] as String,
    json['foto'] as String,
    json['practiques'] as String,
    json['projectes'] as String,
    json['username'] as String,
    json['nom'] as String,
    json['cognoms'] as String,
    json['email'] as String,
  );
}

Map<String, dynamic> _$MeToJson(Me instance) => <String, dynamic>{
      'assignatures': instance.assignatures,
      'avisos': instance.avisos,
      'classes': instance.classes,
      'foto': instance.foto,
      'practiques': instance.practiques,
      'projectes': instance.projectes,
      'username': instance.username,
      'nom': instance.nom,
      'cognoms': instance.cognoms,
      'email': instance.email,
    };
