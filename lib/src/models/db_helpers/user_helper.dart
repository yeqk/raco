import 'package:raco/src/models/me.dart';

class UserHelper {
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
  String avatarPath;

  UserHelper(this.assignatures, this.avisos, this.classes, this.foto, this.practiques,
      this.projectes, this.username, this.nom, this.cognoms, this.email, this.avatarPath);

  UserHelper.fromMe(Me me, String avatarPath) {
    assignatures = me.assignatures;
    avisos = me.avisos;
    classes = me.classes;
    foto = me.foto;
    practiques = me.practiques;
    projectes = me.projectes;
    username = me.username;
    nom = me.nom;
    cognoms = me.cognoms;
    email = me.email;
    this.avatarPath = avatarPath;
  }

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
      'avatarPath': avatarPath
    };
    return map;
  }

  UserHelper.fromMap(Map<String, dynamic> map) {
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
    avatarPath = map['avatarPath'];
  }


}