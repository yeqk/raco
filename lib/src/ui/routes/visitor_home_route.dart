import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:raco/src/blocs/authentication/authentication_bloc.dart';
import 'package:raco/src/blocs/authentication/authentication_event.dart';

class VisitorHomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Visitor Home'),
      ),
      body: Container(
        child: Center(
            child: RaisedButton(
              child: Text('visitor logout'),
              onPressed: () {
                authenticationBloc.dispatch(LoggedOutEvent());
              },
            )),
      ),
    );
  }
}