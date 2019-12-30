// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_downloads.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomDownloads _$CustomDownloadsFromJson(Map<String, dynamic> json) {
  return CustomDownloads(
    json['count'] as int,
    (json['name'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$CustomDownloadsToJson(CustomDownloads instance) =>
    <String, dynamic>{
      'count': instance.count,
      'name': instance.name,
    };
