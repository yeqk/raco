import 'package:raco/flutter_datetime_picker-1.2.8-with-ca/src/date_format.dart';
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/models/custom_grades.dart';
import 'package:raco/src/models/models.dart';
import 'package:raco/src/repositories/repositories.dart';

class CustomGradeHelper {
  String id;
  String subjectId;
  String name;
  String comments;
  String data;
  double grade;
  double percentage;
  String username;


  CustomGradeHelper.fromCustomGrade(CustomGrade grade, String username) {
    this.id = grade.id;
    this.subjectId = grade.subjectId;
    this.name = grade.name;
    this.comments = grade.comments;
    this.data = grade.data;
    this.grade = grade.grade;
    this.percentage = grade.percentage;
    this.username = username;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'subjectId': subjectId,
      'name': name,
      'comments': comments,
      'data': data,
      'grade': grade,
      'percentage': percentage,
      'username': username
    };
    return map;
  }

  CustomGradeHelper.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    subjectId = map['subjectId'];
    name = map['name'];
    comments = map['comments'];
    data = map['data'];
    grade = map['grade'];
    percentage = map['percentage'];
    username = map['username'];
  }
}