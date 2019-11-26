import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:flutter/services.dart';
import 'package:raco/src/ui/routes/drawer_menu/subjects.dart';

import 'configuration.dart';
import 'exams.dart';
import 'grades.dart';
import 'labs.dart';

class DrawerMenu extends Drawer {
  @override
  Widget build(BuildContext context) {


    final AuthenticationBloc authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(context);

    _onSignOutPressed() {
      Navigator.of(context).pop();
      authenticationBloc.dispatch(LoggedOutEvent());
    }

    _onSubjectsPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Subjects()),
      );
    }

    _onExamsPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Exams()),
      );
    }

    _onGradesPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Grades()),
      );
    }

    _onLabsPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Labs()),
      );
    }

    _onFeedBackPressed() {
      print('feedback pressed');
    }

    _onConfigurationPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Configuration()),
      );
    }

    String nom = Dme().nom + ' ' + Dme().cognoms;
    return SafeArea(
        child: new Drawer(
          child: new ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(nom),
                accountEmail: Text(Dme().email),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? Colors.lightBlue
                      : Colors.white,
                  backgroundImage: FileImage(File(Dme().imgPath)),
                ),
              ),
              _listTile(allTranslations.text('subjects'), new Icon(Icons.collections_bookmark), () => _onSubjectsPressed()),
              _listTile(allTranslations.text('exams'), new Icon(Icons.event_busy), () => _onExamsPressed()),
              _listTile(allTranslations.text('grades'), new Icon(Icons.grade), () => _onGradesPressed()),
              _listTile(allTranslations.text('labs'), new Icon(Icons.laptop), () => _onLabsPressed()),
              _listTile(allTranslations.text('feedback'), new Icon(Icons.feedback), () => _onFeedBackPressed()),
              _listTile(allTranslations.text('configuration'), new Icon(Icons.build), () => _onConfigurationPressed()),
              _listTile(allTranslations.text('signout'), new Icon(Icons.close), () => _onSignOutPressed()),
            ],
          ),
        ),
      );
  }

  Widget _listTile(String text, Icon icon, VoidCallback onPressed) {
    return new ListTile(
      title: new Text(text),
      leading: icon,
      onTap: () => onPressed(),
    );
  }


}
