import 'package:raco/src/models/models.dart';

class ExamHelper {
  int altid;
  int id;
  String assig;
  String aules;
  String inici;
  String fi;
  int quatr;
  int curs;
  String pla;
  String tipus;
  String comentaris;
  String eslaboratori;
  String username;

  ExamHelper.fromExamen(Examen examen, String username) {
    this.id = examen.id;
    this.assig = examen.assig;
    this.aules = examen.aules;
    this.inici = examen.inici;
    this.fi = examen.fi;
    this.quatr = examen.quatr;
    this.curs = examen.curs;
    this.pla = examen.pla;
    this.tipus = examen.tipus;
    this.comentaris = examen.comentaris;
    this.eslaboratori = examen.eslaboratori;
    this.username = username;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'assig': assig,
      'aules': aules,
      'inici': inici,
      'fi': fi,
      'quatr': quatr,
      'curs': curs,
      'pla': pla,
      'tipus': tipus,
      'comentaris': comentaris,
      'eslaboratori': eslaboratori,
      'username': username
    };
    return map;
  }

  ExamHelper.fromMap(Map<String, dynamic> map) {
    altid = map['altid'];
    id = map['id'];
    assig = map['assig'];
    aules = map['aules'];
    inici = map['inici'];
    fi = map['fi'];
    quatr = map['quatr'];
    curs = map['curs'];
    pla = map['pla'];
    tipus = map['tipus'];
    comentaris = map['comentaris'];
    eslaboratori = map['eslaboratori'];
    username = map['username'];
  }
}