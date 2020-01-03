import 'package:json_annotation/json_annotation.dart';
import 'package:raco/src/models/db_helpers/exam_helper.dart';

part 'examens.g.dart';

@JsonSerializable(explicitToJson: true)
class Examens {
  int count;
  List<Examen> results;


  Examens(this.count, this.results);

  factory Examens.fromJson(Map<String, dynamic> json) =>
      _$ExamensFromJson(json);

  Map<String, dynamic> toJson() => _$ExamensToJson(this);
}

@JsonSerializable()
class Examen {
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

  Examen(this.id, this.assig, this.aules, this.inici, this.fi, this.quatr,
      this.curs, this.pla, this.tipus, this.comentaris, this.eslaboratori);

  Examen.fromExamHelper(ExamHelper examHelper) {
    this.id = examHelper.id;
    this.assig = examHelper.assig;
    this.aules = examHelper.aules;
    this.inici = examHelper.inici;
    this.fi = examHelper.fi;
    this.quatr = examHelper.quatr;
    this.curs = examHelper.curs;
    this.pla = examHelper.pla;
    this.tipus = examHelper.tipus;
    this.comentaris = examHelper.comentaris;
    this.eslaboratori = examHelper.eslaboratori;
  }

  factory Examen.fromJson(Map<String, dynamic> json) =>
      _$ExamenFromJson(json);

  Map<String, dynamic> toJson() => _$ExamenToJson(this);
}