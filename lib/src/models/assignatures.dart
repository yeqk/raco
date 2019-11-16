import 'package:json_annotation/json_annotation.dart';

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

  factory Assignatura.fromJson(Map<String, dynamic> json) =>
      _$AssignaturaFromJson(json);
  Map<String, dynamic> toJson() => _$AssignaturaToJson(this);
}
