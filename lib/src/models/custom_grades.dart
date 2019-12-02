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
  String nome;
  String comments;
  double percentage;

  CustomGrade(this.id, this.subjectId,this.nome, this.comments, this.percentage);

  factory CustomGrade.fromJson(Map<String, dynamic> json) =>
      _$CustomGradeFromJson(json);

  Map<String, dynamic> toJson() => _$CustomGradeToJson(this);
}

