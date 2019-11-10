import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:raco/src/blocs/drawer_menu/drawer_bloc.dart';

import 'package:raco/src/resources/authentication_data.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/blocs/login/login.dart';
import 'package:raco/src/ui/routes/oauth2_login_route.dart';


class DrawerMenuBloc extends Bloc<DrawerMenuEvent, DrawerMenuState> {


  DrawerMenuState get initialState => DrawerMenuNotPressedState();

  @override
  Stream<DrawerMenuState> mapEventToState(DrawerMenuEvent event) async* {
    if (event is DrawerIconPressedEvent) {
      yield DrawerMenuPressedState();
    }

    if (event is DrawerIconNotPressedEvent) {
      yield DrawerMenuNotPressedState();
    }
  }
}