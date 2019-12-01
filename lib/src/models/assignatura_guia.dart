import 'package:json_annotation/json_annotation.dart';

part 'assignatura_guia.g.dart';

@JsonSerializable(explicitToJson: true)
class AssignaturaGuia {
  String id;
  String competencies;
  Hores hores;
  List<Objectiu> objectius;
  List<Contingut> continguts;
  List<Activitat> activitats;
  @JsonKey(name: 'actes_avaluatius')
  List<ActeAvaluatiu> actesAvaluatius;
  List<Professor> professors;
  List<String> urls;
  Bibliografia bibliografia;
  @JsonKey(name: 'ordre_activitats')
  List<int> ordreActivitats;
  double credits;
  String mail;
  String web;
  String departament;
  String nom;
  String descripcio;
  @JsonKey(name: 'metodologia_docent')
  String metodologiaDocent;
  @JsonKey(name: 'metodologia_avaluacio')
  String metodologiaAvaluacio;
  @JsonKey(name: 'capacitats_previes')
  String capacitatsPrevies;


  AssignaturaGuia(this.id, this.competencies, this.hores, this.objectius,
      this.continguts, this.activitats, this.actesAvaluatius, this.professors,
      this.urls, this.bibliografia, this.ordreActivitats, this.credits,
      this.mail, this.web, this.departament, this.nom, this.descripcio,
      this.metodologiaDocent, this.metodologiaAvaluacio,
      this.capacitatsPrevies);

  factory AssignaturaGuia.fromJson(Map<String, dynamic> json) =>
      _$AssignaturaGuiaFromJson(json);

  Map<String, dynamic> toJson() => _$AssignaturaGuiaToJson(this);
}

@JsonSerializable()
class Hores {
  @JsonKey(name: 'aprenentatge_autonom')
  double aprenentatgeAutonom;
  @JsonKey(name: 'aprenentatge_dirigit')
  double aprenentatgeDirigit;
  double laboratori;
  double problemes;
  double teoria;
  double addicional;

  Hores(this.aprenentatgeAutonom, this.aprenentatgeDirigit, this.laboratori,
      this.problemes, this.teoria, this.addicional);

  factory Hores.fromJson(Map<String, dynamic> json) =>
      _$HoresFromJson(json);
  Map<String, dynamic> toJson() => _$HoresToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Objectiu {
  int id;
  List<String> competencies;
  List<String> subobjectius;
  String valor;

  Objectiu(this.id, this.competencies, this.subobjectius, this.valor);

  factory Objectiu.fromJson(Map<String, dynamic> json) =>
      _$ObjectiuFromJson(json);
  Map<String, dynamic> toJson() => _$ObjectiuToJson(this);
}

@JsonSerializable()
class Contingut {
  int id;
  String nom;
  String descripcio;

  Contingut(this.id, this.nom, this.descripcio);

  factory Contingut.fromJson(Map<String, dynamic> json) =>
      _$ContingutFromJson(json);
  Map<String, dynamic> toJson() => _$ContingutToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Activitat {
  int id;
  Teoria teoria;
  Laboratori laboratori;
  @JsonKey(name: 'aprenentatge_autonom')
  AprenentatgeAutonom aprenentatgeAutonom;
  @JsonKey(name: 'aprenentatge_dirigit')
  AprenentatgeDirigit aprenentatgeDirigit;
  Problemes problemes;
  List<int> continguts;
  List<double> objectius;
  String nom;
  String descripcio;

  Activitat(this.id, this.teoria, this.laboratori, this.aprenentatgeAutonom,
      this.aprenentatgeDirigit, this.problemes, this.continguts, this.objectius,
      this.nom, this.descripcio);

  factory Activitat.fromJson(Map<String, dynamic> json) =>
      _$ActivitatFromJson(json);
  Map<String, dynamic> toJson() => _$ActivitatToJson(this);
}

@JsonSerializable()
class Teoria {
  double hores;
  String descripcio;

  Teoria(this.hores, this.descripcio);

  factory Teoria.fromJson(Map<String, dynamic> json) =>
      _$TeoriaFromJson(json);
  Map<String, dynamic> toJson() => _$TeoriaToJson(this);
}

@JsonSerializable()
class Laboratori {
  double hores;
  String descripcio;

  Laboratori(this.hores, this.descripcio);

  factory Laboratori.fromJson(Map<String, dynamic> json) =>
      _$LaboratoriFromJson(json);
  Map<String, dynamic> toJson() => _$LaboratoriToJson(this);
}

@JsonSerializable()
class AprenentatgeAutonom {
  double hores;
  String descripcio;

  AprenentatgeAutonom(this.hores, this.descripcio);

  factory AprenentatgeAutonom.fromJson(Map<String, dynamic> json) =>
      _$AprenentatgeAutonomFromJson(json);
  Map<String, dynamic> toJson() => _$AprenentatgeAutonomToJson(this);
}

@JsonSerializable()
class AprenentatgeDirigit {
  double hores;
  String descripcio;

  AprenentatgeDirigit(this.hores, this.descripcio);

  factory AprenentatgeDirigit.fromJson(Map<String, dynamic> json) =>
      _$AprenentatgeDirigitFromJson(json);
  Map<String, dynamic> toJson() => _$AprenentatgeDirigitToJson(this);
}

@JsonSerializable()
class Problemes {
  double hores;
  String descripcio;

  Problemes(this.hores, this.descripcio);

  factory Problemes.fromJson(Map<String, dynamic> json) =>
      _$ProblemesFromJson(json);
  Map<String, dynamic> toJson() => _$ProblemesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ActeAvaluatiu {
  int id;
  @JsonKey(name: 'fora_horaris')
  bool foraHoraris;
  List<int> objectius;
  int setmana;
  String tipus;
  @JsonKey(name: 'hores_duracio')
  int horesDuracio;
  @JsonKey(name: 'hores_estudi')
  int horesEstudi;
  String data;
  String nom;
  String descripcio;

  ActeAvaluatiu(this.id, this.foraHoraris, this.objectius, this.setmana,
      this.tipus, this.horesDuracio, this.horesEstudi, this.data, this.nom,
      this.descripcio);

  factory ActeAvaluatiu.fromJson(Map<String, dynamic> json) =>
      _$ActeAvaluatiuFromJson(json);
  Map<String, dynamic> toJson() => _$ActeAvaluatiuToJson(this);
}

@JsonSerializable()
class Professor {
  String nom;
  String email;
  @JsonKey(name: 'is_responsable')
  bool isResponsable;

  Professor(this.nom, this.email, this.isResponsable);

  factory Professor.fromJson(Map<String, dynamic> json) =>
      _$ProfessorFromJson(json);
  Map<String, dynamic> toJson() => _$ProfessorToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Bibliografia {
  List<Biblio> basica;
  List<Biblio> complementaria;

  Bibliografia(this.basica, this.complementaria);

  factory Bibliografia.fromJson(Map<String, dynamic> json) =>
      _$BibliografiaFromJson(json);
  Map<String, dynamic> toJson() => _$BibliografiaToJson(this);
}

@JsonSerializable()
class Biblio {
  int id;
  String titol;
  String autor;
  String editorial;
  @JsonKey(name: 'any_bib')
  String anyBib;
  @JsonKey(name: 'disponible_biblioteca')
  bool disponibleBiblioteca;
  String edicio;
  String isbn;
  String url;

  Biblio(this.id, this.titol, this.autor, this.editorial, this.anyBib,
      this.disponibleBiblioteca, this.edicio, this.isbn, this.url);

  factory Biblio.fromJson(Map<String, dynamic> json) =>
      _$BiblioFromJson(json);
  Map<String, dynamic> toJson() => _$BiblioToJson(this);
}

