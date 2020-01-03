import 'package:raco/src/models/models.dart';

class AttachmentHelper {
  int id;
  String tipusMime;
  String nom;
  String url;
  String dataModificacio;
  int mida;
  int noticeId;

  AttachmentHelper(this.tipusMime, this.nom, this.url, this.dataModificacio, this.mida, this.noticeId);

  AttachmentHelper.fromAdjunt(Adjunt adjunt, int noticeId) {
    this.tipusMime = adjunt.tipusMime;
    this.nom = adjunt.nom;
    this.url = adjunt.url;
    this.dataModificacio = adjunt.dataModificacio;
    this.mida = adjunt.mida;
    this.noticeId = noticeId;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'tipusMime': tipusMime,
      'nom': nom,
      'url': url,
      'dataModificacio': dataModificacio,
      'mida': mida,
      'noticeId': noticeId,
    };
    return map;
  }

  AttachmentHelper.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    tipusMime = map['tipusMime'];
    nom = map['nom'];
    url = map['url'];
    dataModificacio = map['dataModificacio'];
    mida = map['mida'];
    noticeId = map['noticeId'];
  }
}