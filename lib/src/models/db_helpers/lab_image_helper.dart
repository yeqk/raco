import 'package:raco/src/models/models.dart';

class LabImageHelper {
  String name;
  String path;


  LabImageHelper(this.name, this.path);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'path': path,
    };
    return map;
  }

  LabImageHelper.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    path = map['path'];
  }
}