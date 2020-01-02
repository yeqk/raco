import 'package:json_annotation/json_annotation.dart';

part 'me.g.dart';

@JsonSerializable()

class Me {
  String assignatures;
  String avisos;
  String classes;
  String foto;
  String practiques;
  String projectes;
  String username;
  String nom;
  String cognoms;
  String email;

  Me(this.assignatures, this.avisos, this.classes, this.foto, this.practiques,
      this.projectes, this.username, this.nom, this.cognoms, this.email);

  factory Me.fromJson(Map<String, dynamic> json) => _$MeFromJson(json);

  Map<String, dynamic> toJson() => _$MeToJson(this);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'assignatures': assignatures,
      'avisos': avisos,
      'classes': classes,
      'foto': foto,
      'practiques': practiques,
      'projectes': projectes,
      'username': username,
      'nom': nom,
      'cognoms': cognoms,
      'email': email,
    };
    return map;
  }

  Me.fromMap(Map<String, dynamic> map) {
    assignatures = map['assignatures'];
    avisos = map['avisos'];
    classes = map['classes'];
    foto = map['foto'];
    practiques = map['practiques'];
    projectes = map['projectes'];
    username = map['username'];
    nom = map['nom'];
    cognoms = map['cognoms'];
    email = map['email'];
  }


}