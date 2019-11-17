import 'package:json_annotation/json_annotation.dart';

part 'quadrimestre.g.dart';

@JsonSerializable()
class Quadrimestre {
  String id;
  String url;
  String actual;
  @JsonKey(name: 'actual_horaris')
  String acutalHoraris;
  String classes;
  String examens;
  String assignatures;

  Quadrimestre(this.id, this.url, this.actual, this.acutalHoraris, this.classes,
      this.examens, this.assignatures);

  factory Quadrimestre.fromJson(Map<String, dynamic> json) =>
      _$QuadrimestreFromJson(json);

  Map<String, dynamic> toJson() => _$QuadrimestreToJson(this);
}
