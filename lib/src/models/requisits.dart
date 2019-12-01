import 'package:json_annotation/json_annotation.dart';

part 'requisits.g.dart';

@JsonSerializable(explicitToJson: true)
class Requisits {
  int count;
  List<Requisit> results;

  Requisits(this.count, this.results);

  factory Requisits.fromJson(Map<String, dynamic> json) =>
      _$RequisitsFromJson(json);

  Map<String, dynamic> toJson() => _$RequisitsToJson(this);
}

@JsonSerializable()
class Requisit {
  String origin;
  String destination;
  String tipus;


  Requisit(this.origin, this.destination, this.tipus);

  factory Requisit.fromJson(Map<String, dynamic> json) =>
      _$RequisitFromJson(json);

  Map<String, dynamic> toJson() => _$RequisitToJson(this);
}
