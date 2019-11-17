import 'package:json_annotation/json_annotation.dart';

part 'noticies.g.dart';

@JsonSerializable(explicitToJson: true)
class Noticies {
  int count;
  List<Noticia> results;

  Noticies(this.count, this.results);

  factory Noticies.fromJson(Map<String, dynamic> json) =>
      _$NoticiesFromJson(json);

  Map<String, dynamic> toJson() => _$NoticiesToJson(this);
}

@JsonSerializable()
class Noticia {
  String titol;
  String link;
  String descripcio;
  @JsonKey(name: "data_publicacio")
  String dataPublicacio;


  Noticia(this.titol, this.link, this.descripcio, this.dataPublicacio);

  factory Noticia.fromJson(Map<String, dynamic> json) =>
      _$NoticiaFromJson(json);

  Map<String, dynamic> toJson() => _$NoticiaToJson(this);
}
