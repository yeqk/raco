import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/blocs/authentication/authentication_bloc.dart';
import 'package:raco/src/blocs/authentication/authentication_event.dart';
import 'package:raco/src/resources/global_translations.dart';

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      appBar: AppBar(
      ),
      body: Container(
        child: Center(
            child: RaisedButton(
              child: Text(allTranslations.text('signout')),
              onPressed: () {
                authenticationBloc.dispatch(LoggedOutEvent());
              },
            )),
      ),
    );
  }
}