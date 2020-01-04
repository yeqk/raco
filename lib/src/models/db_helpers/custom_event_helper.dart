import 'package:raco/flutter_datetime_picker-1.2.8-with-ca/src/date_format.dart';
import 'package:raco/src/models/custom_events.dart';
import 'package:raco/src/models/models.dart';

class CustomEventHelper {
  String id;
  String title;
  String description;
  String inici;
  String fi;
  String username;


  CustomEventHelper.fromCustomEvent(CustomEvent event, String username) {
    this.id = event.id;
    this.title = event.title;
    this.description = event.description;
    this.inici = event.inici;
    this.fi = event.fi;
    this.username = username;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'inici': inici,
      'fi': fi,
      'username': username
    };
    return map;
  }

  CustomEventHelper.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    inici = map['inici'];
    fi = map['fi'];
    username = map['username'];
  }
}