import 'package:raco/src/models/models.dart';

class ScheduleHelper {
  int id;
  String username;
  String codiAssig;
  String grup;
  int diaSetmana;
  String inici;
  int durada;
  String tipus;
  String aules;

  ScheduleHelper(this.id, this.username,this.codiAssig, this.grup, this.diaSetmana, this.inici, this.durada,
      this.tipus, this.aules);


  ScheduleHelper.fromClasse(Classe classe, String username) {
    this.username = username;
    this.codiAssig = classe.codiAssig;
    this.grup = classe.grup;
    this.diaSetmana = classe.diaSetmana;
    this.inici = classe.inici;
    this.durada = classe.durada;
    this.tipus = classe.tipus;
    this.aules = classe.aules;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'username': username,
      'codiAssig': codiAssig,
      'grup': grup,
      'diaSetmana': diaSetmana,
      'inici': inici,
      'durada': durada,
      'tipus': tipus,
      'aules': aules,
    };
    return map;
  }

  ScheduleHelper.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    username = map['username'];
    codiAssig = map['codiAssig'];
    grup = map['grup'];
    diaSetmana = map['diaSetmana'];
    inici = map['inici'];
    durada = map['durada'];
    tipus = map['tipus'];
    aules = map['aules'];
  }

}