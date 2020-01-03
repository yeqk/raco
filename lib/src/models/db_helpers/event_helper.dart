import 'package:raco/src/models/models.dart';

class EventHelper {
  int id;
  String nom;
  String inici;
  String fi;

  EventHelper(this.id, this.nom, this.inici, this.fi);

  EventHelper.fromEvent(Event event) {
    this.nom = event.nom;
    this.inici = event.inici;
    this.fi = event.fi;

  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nom': nom,
      'inici': inici,
      'fi': fi,

    };
    return map;
  }

  EventHelper.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nom = map['nom'];
    inici = map['inici'];
    fi = map['fi'];

  }
}