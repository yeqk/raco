import 'dart:io';

import 'package:flutter/cupertino.dart';
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
      if (Platform.isAndroid) {
        showCupertinoDialog(context: context, builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: new Text(allTranslations.text('signout')),
            content: new Text(allTranslations.text('signout_message')),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(allTranslations.text('cancel')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text(allTranslations.text('accept')),
                onPressed: () {
                  Navigator.of(context).pop();
                  authenticationBloc.dispatch(LoggedOutEvent());
                },
              )
            ],
          );
        });
      } else {
        showDialog(context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(allTranslations.text('signout')),
            content: new Text(allTranslations.text('signout_message')),
            actions: <Widget>[
              FlatButton(
                child: Text(allTranslations.text('cancel')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(allTranslations.text('accept')),
                onPressed: () {
                  Navigator.of(context).pop();
                  authenticationBloc.dispatch(LoggedOutEvent());
                },
              ),
            ],
          );
        });
      }
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
