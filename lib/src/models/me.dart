import 'package:json_annotation/json_annotation.dart';
import 'package:raco/flutter_datetime_picker-1.2.8-with-ca/src/date_format.dart';

import 'db_helpers/user_helper.dart';

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

  Me.fromHelper(UserHelper userHelper) {
    assignatures = userHelper.assignatures;
    avisos = userHelper.avisos;
    classes = userHelper.classes;
    foto = userHelper.foto;
    practiques = userHelper.practiques;
    projectes = userHelper.projectes;
    username = userHelper.username;
    nom = userHelper.nom;
    cognoms = userHelper.cognoms;
    email = userHelper.email;
  }

  factory Me.fromJson(Map<String, dynamic> json) => _$MeFromJson(json);

  Map<String, dynamic> toJson() => _$MeToJson(this);


}