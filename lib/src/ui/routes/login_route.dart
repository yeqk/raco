import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/blocs/login/login.dart';
import 'package:raco/src/blocs/authentication/authentication_bloc.dart';
import 'package:raco/src/blocs/login/login_bloc.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/ui/widgets/login_form.dart';

class LoginRoute extends StatelessWidget {

  LoginRoute({Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text('home')),
      ),
      body: BlocProvider(
        builder: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          );
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return LoginForm();
          },
        ),
      ),
    );
  }
}