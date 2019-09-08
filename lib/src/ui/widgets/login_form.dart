import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:raco/src/blocs/login/login_bloc.dart';
import 'package:raco/src/blocs/login/login_event.dart';
import 'package:raco/src/blocs/login/login_state.dart';
import 'package:raco/src/ui/routes/routes.dart';
import 'package:raco/src/resources/oauth2_data.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onLoginButtonPressed() {
      _loginBloc.dispatch(LoginButtonPressedEvent(context: context));
    }

    _onVisitButtonPressed() {
      _loginBloc.dispatch(VisitButtonPressedEvent());
    }

    return BlocBuilder<LoginBloc, LoginState>(
      bloc: _loginBloc,
      builder: (context, state) {

          return Center(
              child: Form(
                child: Column(
                  children: [
                    RaisedButton(
                      onPressed: _onLoginButtonPressed,
                      child: Text('Login'),
                    ),
                    RaisedButton(
                      onPressed: _onVisitButtonPressed,
                      child: Text('Visit'),
                    ),
                  ],
                ),
              ));
      },
    );
  }
}
