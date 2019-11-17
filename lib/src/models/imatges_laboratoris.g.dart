// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imatges_laboratoris.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImatgesLaboratoris _$ImatgesLaboratorisFromJson(Map<String, dynamic> json) {
  return ImatgesLaboratoris(
    json['imatges'] == null
        ? null
        : Imatges.fromJson(json['imatges'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ImatgesLaboratorisToJson(ImatgesLaboratoris instance) =>
    <String, dynamic>{
      'imatges': instance.imatges?.toJson(),
    };

Imatges _$ImatgesFromJson(Map<String, dynamic> json) {
  return Imatges(
    json['A5'] as String,
    json['C6'] as String,
    json['B5'] as String,
  );
}

Map<String, dynamic> _$ImatgesToJson(Imatges instance) => <String, dynamic>{
      'A5': instance.A5,
      'C6': instance.C6,
      'B5': instance.B5,
    };
