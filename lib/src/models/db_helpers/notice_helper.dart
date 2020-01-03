import 'package:raco/src/models/models.dart';

class NoticeHelper {
  int id;
  String titol;
  String codiAssig;
  String textContent;
  String dataInsercio;
  String dataModificacio;
  String dataCaducitat;
  String username;

  NoticeHelper(this.id, this.titol, this.codiAssig, this.textContent, this.dataInsercio,
      this.dataModificacio);

  NoticeHelper.fromAvis(Avis avis, String username) {
    this.id = avis.id;
    this.titol = avis.titol;
    this.codiAssig = avis.codiAssig;
    this.textContent = avis.text;
    this.dataInsercio = avis.dataInsercio;
    this.dataModificacio = avis.dataModificacio;
    this.dataCaducitat = avis.dataCaducitat;
    this.username = username;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'titol': titol,
      'codiAssig': codiAssig,
      'textContent': textContent,
      'dataInsercio': dataInsercio,
      'dataModificacio': dataModificacio,
      'dataCaducitat': dataCaducitat,
      'username': username,
    };
    return map;
  }

  NoticeHelper.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    titol = map['titol'];
    codiAssig = map['codiAssig'];
    textContent = map['textContent'];
    dataInsercio = map['dataInsercio'];
    dataModificacio = map['dataModificacio'];
    dataCaducitat = map['dataCaducitat'];
    username = map['username'];
  }
}