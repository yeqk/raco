import 'package:json_annotation/json_annotation.dart';

part 'custom_grades.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomGrades {
  int count;
  List<CustomGrade> results;


  CustomGrades(this.count, this.results);

  factory CustomGrades.fromJson(Map<String, dynamic> json) =>
      _$CustomGradesFromJson(json);

  Map<String, dynamic> toJson() => _$CustomGradesToJson(this);
}

@JsonSerializable()
class CustomGrade {
  String id;
  String subjectId;
  String name;
  String comments;
  double grade;
  double percentage;

  CustomGrade(this.id, this.subjectId,this.name, this.comments, this.grade,this.percentage);

  factory CustomGrade.fromJson(Map<String, dynamic> json) =>
      _$CustomGradeFromJson(json);

  Map<String, dynamic> toJson() => _$CustomGradeToJson(this);
}

