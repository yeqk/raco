import 'package:json_annotation/json_annotation.dart';

part 'classes.g.dart';

@JsonSerializable(explicitToJson: true)
class Classes {
  int count;
  List<Classe> results;

  Classes(this.count, this.results);

  factory Classes.fromJson(Map<String, dynamic> json) => _$ClassesFromJson(json);

  Map<String, dynamic> toJson() => _$ClassesToJson(this);
}

@JsonSerializable()
class Classe {
  @JsonKey(name: "codi_assig")
  String codiAssig;
  String grup;
  @JsonKey(name: "dia_setmana")
  int diaSetmana;
  String inici;
  int durada;
  String tipus;
  String aules;

  Classe(this.codiAssig, this.grup, this.diaSetmana, this.inici, this.durada,
      this.tipus, this.aules);

  factory Classe.fromJson(Map<String, dynamic> json) => _$ClasseFromJson(json);
  Map<String, dynamic> toJson() => _$ClasseToJson(this);
}