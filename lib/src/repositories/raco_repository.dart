import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:raco/src/models/classes.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/models/requisits.dart';
import 'raco_api_client.dart';

class RacoRepository {
  final RacoApiClient racoApiClient;

  RacoRepository({@required this.racoApiClient})
      : assert(racoApiClient != null);

  Future<Me> getMe() async {
    return await racoApiClient.getMe();
  }

  Future<String> getImage() async {
    return await racoApiClient.getImage();
  }

  Future<String> getImageA5() async {
    return await racoApiClient.getImageA5();
  }

  Future<String> getImageC6() async {
    return await racoApiClient.getImageC6();
  }

  Future<String> getImageB5() async {
    return await racoApiClient.getImageB5();
  }

  Future<Classes> getClasses() async {
    return await racoApiClient.getClasses();
  }

  Future<Requisits> getRequisists() async {
    return await racoApiClient.getRequisits();
  }
  Future<Assignatures> getAssignatures() async {
    return await racoApiClient.getAssignatures();
  }

  Future<AssignaturaURL> getAssignaturaURL(Assignatura assignatura) async {
    return await racoApiClient.getAssignaturaURL(assignatura);
  }

  Future<AssignaturaGuia> getAssignaturaGuia(Assignatura assignatura) async {
    return await racoApiClient.getAssignaturaGuia(assignatura);
  }

  Future<Avisos> getAvisos() async {
    return await racoApiClient.getAvisos();
  }

  Future<Events> getEvents() async {
    return await racoApiClient.getEvents();
  }

  Future<Noticies> getNoticies() async {
    return await racoApiClient.getNoticies();
  }

  Future<ExamensLaboratori> getExamensLaboratori() async {
    return await racoApiClient.getExamsLaboratori();
  }

  Future<Quadrimestre> getQuadrimestreActual() async {
    return await racoApiClient.getQuadrimestreActual();
  }

  Future<Examens> getExamens(Quadrimestre actual) async {
    return await racoApiClient.getExamens(actual);
  }

  Future<String> downloadAndSaveFile(String name, String url, String mimeType) async {
    return await racoApiClient.downloadAndSaveFile(name, url, mimeType);
  }
}
