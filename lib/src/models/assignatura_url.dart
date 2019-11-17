import 'package:json_annotation/json_annotation.dart';

part 'assignatura_url.g.dart';

@JsonSerializable(explicitToJson: true)
class AssignaturaURL {
  String id;
  String url;
  String guia;
  List<Obligatorietat> obligatorietats;
  List<String> plans;
  Lang lang;
  List<String> quadrimestres;
  String sigles;
  @JsonKey(name: 'codi_upc')
  int codiUPC;
  String semestre;
  double credits;
  String nom;

  AssignaturaURL(
      this.id,
      this.url,
      this.guia,
      this.obligatorietats,
      this.plans,
      this.lang,
      this.quadrimestres,
      this.sigles,
      this.codiUPC,
      this.semestre,
      this.credits,
      this.nom);

  factory AssignaturaURL.fromJson(Map<String, dynamic> json) =>
      _$AssignaturaURLFromJson(json);

  Map<String, dynamic> toJson() => _$AssignaturaURLToJson(this);
}

@JsonSerializable()
class Obligatorietat {
  @JsonKey(name: 'codi_oblig')
  String codiOblig;
  @JsonKey(name: 'codi_especialitat')
  String codiEspecialitat;
  String pla;
  @JsonKey(name: 'nom_especialitat')
  String nomEspecialitat;

  Obligatorietat(
      this.codiOblig, this.codiEspecialitat, this.pla, this.nomEspecialitat);

  factory Obligatorietat.fromJson(Map<String, dynamic> json) =>
      _$ObligatorietatFromJson(json);

  Map<String, dynamic> toJson() => _$ObligatorietatToJson(this);
}

@JsonSerializable()
class Lang {
  @JsonKey(name: 'Q1')
  List<String> q1;
  @JsonKey(name: 'Q2')
  List<String> q2;

  Lang(this.q1, this.q2);

  factory Lang.fromJson(Map<String, dynamic> json) => _$LangFromJson(json);

  Map<String, dynamic> toJson() => _$LangToJson(this);
}
