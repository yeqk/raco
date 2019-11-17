import 'package:json_annotation/json_annotation.dart';

part 'imatges_laboratoris.g.dart';

@JsonSerializable(explicitToJson: true)
class ImatgesLaboratoris {
  Imatges imatges;


  ImatgesLaboratoris(this.imatges);

  factory ImatgesLaboratoris.fromJson(Map<String, dynamic> json) =>
      _$ImatgesLaboratorisFromJson(json);

  Map<String, dynamic> toJson() => _$ImatgesLaboratorisToJson(this);
}

@JsonSerializable()
class Imatges {
  String A5;
  String C6;
  String B5;


  Imatges(this.A5, this.C6, this.B5);

  factory Imatges.fromJson(Map<String, dynamic> json) =>
      _$ImatgesFromJson(json);

  Map<String, dynamic> toJson() => _$ImatgesToJson(this);
}