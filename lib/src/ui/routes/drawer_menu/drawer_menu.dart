import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/data/dme.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:flutter/services.dart';

class DrawerMenu extends Drawer {
  @override
  Widget build(BuildContext context) {


    final AuthenticationBloc authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(context);

    _onSignOutPressed() {
      Navigator.of(context).pop();
      authenticationBloc.dispatch(LoggedOutEvent());
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
              _listTile(allTranslations.text('subjects'), new Icon(Icons.collections_bookmark), () => _onSignOutPressed()),
              _listTile(allTranslations.text('exams'), new Icon(Icons.event_busy), () => _onSignOutPressed()),
              _listTile(allTranslations.text('grades'), new Icon(Icons.grade), () => _onSignOutPressed()),
              _listTile(allTranslations.text('labs'), new Icon(Icons.laptop), () => _onSignOutPressed()),
              _listTile(allTranslations.text('feedback'), new Icon(Icons.feedback), () => _onSignOutPressed()),
              _listTile(allTranslations.text('configuration'), new Icon(Icons.build), () => _onSignOutPressed()),
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
