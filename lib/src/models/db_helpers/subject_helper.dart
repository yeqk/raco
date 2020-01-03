import 'package:raco/src/models/models.dart';

class SubjectHelper {
  String id;
  String url;
  String guia;
  String grup;
  String sigles;
  int codiUPC;
  String semestre;
  double credits;
  String nom;
  String username;

  SubjectHelper.fromAssignatura(Assignatura assignatura, String username) {
    this.id = assignatura.id;
    this.url = assignatura.url;
    this.guia = assignatura.guia;
    this.grup = assignatura.grup;
    this.sigles = assignatura.sigles;
    this.codiUPC = assignatura.codiUPC;
    this.semestre = assignatura.semestre;
    this.credits = assignatura.credits;
    this.nom = assignatura.nom;
    this.username = username;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'url': url,
      'guia': guia,
      'grup': grup,
      'sigles': sigles,
      'codiUPC': codiUPC,
      'semestre': semestre,
      'credits': credits,
      'nom': nom,
      'username': username,
    };
    return map;
  }

  SubjectHelper.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    url = map['url'];
    guia = map['guia'];
    grup = map['grup'];
    sigles = map['sigles'];
    codiUPC = map['codiUPC'];
    semestre = map['semestre'];
    credits = map['credits'];
    nom = map['nom'];
    username = map['username'];

  }
}