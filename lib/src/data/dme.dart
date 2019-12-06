import 'package:raco/src/models/assignatura_guia.dart';
import 'package:raco/src/models/assignatures.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/models/custom_grades.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/models/requisits.dart';

class Dme {
  static final Dme _dme = Dme._internal();

  factory Dme() {
    return _dme;
  }

  Dme._internal();

  String username;
  String nom;
  String cognoms;
  String email;
  String imgPath;
  //key = row + '|' + col
  Map<String, Classe> schedule;
  Assignatures assignatures;
  //random color for each subject Map<subject code, color code>
  Map<String, String> assigColors;
  Map<String, String> defaultAssigColors;
  Requisits requisits;
  Map<String, AssignaturaURL> assigURL;
  Map<String, AssignaturaGuia> assigGuia;
  Avisos avisos;
  Events events;
  Noticies noticies;
  Examens examens;
  ExamensLaboratori labExams;

  String A5;
  String B5;
  String C6;

  CustomEvents customEvents;
  CustomGrades customGrades;

  String lastUpdate;

}