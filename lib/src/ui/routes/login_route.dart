import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/blocs/login/login.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/blocs/authentication/authentication_bloc.dart';
import 'package:raco/src/blocs/login/login_bloc.dart';
import 'package:raco/src/ui/widgets/login_form.dart';
import 'package:raco/src/ui/routes/routes.dart';

class LoginRoute extends StatelessWidget {
  final UserRepository userRepository;

  LoginRoute({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocProvider(
        builder: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
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