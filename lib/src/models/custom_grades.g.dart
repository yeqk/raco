// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_grades.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomGrades _$CustomGradesFromJson(Map<String, dynamic> json) {
  return CustomGrades(
    json['count'] as int,
    (json['results'] as List)
        ?.map((e) =>
            e == null ? null : CustomGrade.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CustomGradesToJson(CustomGrades instance) =>
    <String, dynamic>{
      'count': instance.count,
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };

CustomGrade _$CustomGradeFromJson(Map<String, dynamic> json) {
  return CustomGrade(
    json['id'] as String,
    json['subjectId'] as String,
    json['name'] as String,
    json['comments'] as String,
    (json['grade'] as num)?.toDouble(),
    (json['percentage'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$CustomGradeToJson(CustomGrade instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subjectId': instance.subjectId,
      'name': instance.name,
      'comments': instance.comments,
      'grade': instance.grade,
      'percentage': instance.percentage,
    };
