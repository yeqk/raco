import 'package:json_annotation/json_annotation.dart';

part 'examens_laboratori.g.dart';

@JsonSerializable()
class ExamensLaboratori {
  @JsonKey(name: 'propers_examens_laboratori')
  String propersExamensLaboratori;
  String description;
  String title;
  String assig;
  String aules;
  String inici;
  String fi;
  String comentaris;
  @JsonKey(name: 'entorn_segur')
  String entornSegur;
  @JsonKey(name: 'usb_disponible')
  String usbDisponible;
  String imatge;
  @JsonKey(name: 'tipus_usuari')
  String tipusUsuari;
  @JsonKey(name: 'acces_url')
  String accessURL;
  @JsonKey(name: 'acces_home_dades')
  String accesHomeDades;
  @JsonKey(name: 'observacions_necessitats')
  String observacionsNecessitats;


  ExamensLaboratori(this.propersExamensLaboratori, this.description, this.title,
      this.assig, this.aules, this.inici, this.fi, this.comentaris,
      this.entornSegur, this.usbDisponible, this.imatge, this.tipusUsuari,
      this.accessURL, this.accesHomeDades, this.observacionsNecessitats);

  factory ExamensLaboratori.fromJson(Map<String, dynamic> json) =>
      _$ExamensLaboratoriFromJson(json);

  Map<String, dynamic> toJson() => _$ExamensLaboratoriToJson(this);
}
