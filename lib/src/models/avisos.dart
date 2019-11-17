import 'package:json_annotation/json_annotation.dart';

part 'avisos.g.dart';

@JsonSerializable(explicitToJson: true)
class Avisos {
  int count;
  List<Avis> results;

  Avisos(this.count, this.results);

  factory Avisos.fromJson(Map<String, dynamic> json) =>
      _$AvisosFromJson(json);

  Map<String, dynamic> toJson() => _$AvisosToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Avis {
  int id;
  String titol;
  @JsonKey(name: 'codi_assig')
  String codiAssig;
  String text;
  @JsonKey(name: 'data_insercio')
  String dataInsercio;
  @JsonKey(name: 'data_modificacio')
  String dataModificacio;
  @JsonKey(name: 'data_caducitat')
  String dataCaducitat;
  List<Adjunt> adjunts;

  Avis(this.id, this.titol, this.codiAssig, this.text, this.dataInsercio,
      this.dataModificacio, this.adjunts);

  factory Avis.fromJson(Map<String, dynamic> json) =>
      _$AvisFromJson(json);
  Map<String, dynamic> toJson() => _$AvisToJson(this);
}

@JsonSerializable()
class Adjunt {
  @JsonKey(name: 'tipus_mime')
  String tipusMime;
  String nom;
  String url;
  @JsonKey(name: 'data_modificacio')
  String dataModificacio;
  int mida;

  Adjunt(this.tipusMime, this.nom, this.url, this.dataModificacio, this.mida);

  factory Adjunt.fromJson(Map<String, dynamic> json) =>
      _$AdjuntFromJson(json);
  Map<String, dynamic> toJson() => _$AdjuntToJson(this);
}
