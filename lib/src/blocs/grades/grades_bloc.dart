import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:raco/src/blocs/events/events.dart';
import 'package:raco/src/blocs/grades/grades.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/models/custom_grades.dart';
import 'package:raco/src/models/db_helpers/custom_grade_helper.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/db_repository.dart';
import 'package:raco/src/repositories/raco_api_client.dart';
import 'package:raco/src/repositories/raco_repository.dart';
import 'package:raco/src/repositories/user_repository.dart';
import 'package:raco/src/ui/routes/bottom_navigation/events_route.dart';
import 'package:raco/src/utils/file_names.dart';
import 'package:raco/src/utils/keys.dart';
import 'package:raco/src/utils/read_write_file.dart';
import 'package:http/http.dart' as http;

class GradesBloc extends Bloc<GradesEvent, GradesState> {

  GradesState get initialState => GradesInitState();

  @override
  Stream<GradesState> mapEventToState(GradesEvent event) async* {
    if (event is GradesEvent) {
      yield GradesInitState();
    }

    if (event is GradesAddEvent) {
      Dme().customGrades.count += 1;
      Dme().customGrades.results.add(event.customGrade);
      await dbRepository.insertCustomGradeHelper(CustomGradeHelper.fromCustomGrade(event.customGrade, Dme().username));
/*      await ReadWriteFile().writeStringToFile(
          FileNames.CUSTOM_GRADES,
          jsonEncode(Dme().customGrades));*/
    }

    if (event is GradesDeleteEvent) {
      CustomGrade g = event.customGrade;
      Dme().customGrades.results.removeWhere((i) {
        return i.id == g.id;
      });
      Dme().customGrades.count -= 1;
      await dbRepository.deleteCustomGradeById(event.customGrade.id);
/*      await ReadWriteFile().writeStringToFile(
          FileNames.CUSTOM_GRADES, jsonEncode(Dme().customGrades));*/
      yield GradeDeletedState();
    }

    if (event is GradesEditEvent) {
/*      await ReadWriteFile().writeStringToFile(
          FileNames.CUSTOM_GRADES,
          jsonEncode(Dme().customGrades));*/
      await dbRepository.clearCustomGradeHelperTable();
      Dme().customGrades.results.forEach((cg) async {
        await dbRepository.insertCustomGradeHelper(CustomGradeHelper.fromCustomGrade(cg, Dme().username));
      });
      yield GradeEditedState();
    }


  }
}
