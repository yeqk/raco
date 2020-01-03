import 'package:json_annotation/json_annotation.dart';
import 'package:raco/flutter_datetime_picker-1.2.8-with-ca/src/date_format.dart';
import 'package:raco/src/models/db_helpers/subject_helper.dart';

part 'assignatures.g.dart';

@JsonSerializable(explicitToJson: true)
class Assignatures {
  int count;
  List<Assignatura> results;

  Assignatures(this.count, this.results);

  factory Assignatures.fromJson(Map<String, dynamic> json) =>
      _$AssignaturesFromJson(json);

  Map<String, dynamic> toJson() => _$AssignaturesToJson(this);
}

@JsonSerializable()
class Assignatura {
  String id;
  String url;
  String guia;
  String grup;
  String sigles;
  @JsonKey(name: "codi_upc")
  int codiUPC;
  String semestre;
  double credits;
  String nom;

  Assignatura(this.id, this.url, this.guia, this.grup, this.sigles,
      this.codiUPC, this.semestre, this.credits, this.nom);

  Assignatura.fromSubjectHelper(SubjectHelper subjectHelper) {
    this.id = subjectHelper.id;
    this.url = subjectHelper.url;
    this.guia = subjectHelper.guia;
    this.grup = subjectHelper.grup;
    this.sigles = subjectHelper.sigles;
    this.codiUPC = subjectHelper.codiUPC;
    this.semestre = subjectHelper.semestre;
    this.credits = subjectHelper.credits;
    this.nom = subjectHelper.nom;
  }

  factory Assignatura.fromJson(Map<String, dynamic> json) =>
      _$AssignaturaFromJson(json);
  Map<String, dynamic> toJson() => _$AssignaturaToJson(this);
}
