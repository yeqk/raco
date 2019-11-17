// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quadrimestre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quadrimestre _$QuadrimestreFromJson(Map<String, dynamic> json) {
  return Quadrimestre(
    json['id'] as String,
    json['url'] as String,
    json['actual'] as String,
    json['actual_horaris'] as String,
    json['classes'] as String,
    json['examens'] as String,
    json['assignatures'] as String,
  );
}

Map<String, dynamic> _$QuadrimestreToJson(Quadrimestre instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'actual': instance.actual,
      'actual_horaris': instance.acutalHoraris,
      'classes': instance.classes,
      'examens': instance.examens,
      'assignatures': instance.assignatures,
    };
