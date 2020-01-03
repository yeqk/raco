import 'package:raco/src/models/models.dart';

class NewsHelper {
  int id;
  String titol;
  String link;
  String descripcio;
  String dataPublicacio;

  NewsHelper.fromNoticia(Noticia noticia) {
    this.titol = noticia.titol;
    this.link = noticia.link;
    this.descripcio = noticia.descripcio;
    this.dataPublicacio = noticia.dataPublicacio;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'titol': titol,
      'link': link,
      'descripcio': descripcio,
      'dataPublicacio': dataPublicacio,
    };
    return map;
  }

  NewsHelper.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    titol = map['titol'];
    link = map['link'];
    descripcio = map['descripcio'];
    dataPublicacio = map['dataPublicacio'];

  }
}