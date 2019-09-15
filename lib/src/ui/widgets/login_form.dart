import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/blocs/login/login.dart';
import 'package:raco/src/blocs/translations/translations.dart';
import 'package:raco/src/resources/global_translations.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);
    final _translationBloc = BlocProvider.of<TranslationsBloc>(context);

    _onLoginButtonPressed() {
      _loginBloc.dispatch(LoginButtonPressedEvent(context: context));
    }

    _onVisitButtonPressed() {
      _loginBloc.dispatch(VisitButtonPressedEvent());
    }

    _onChangeLanguagePressed(String code) {
      _translationBloc.dispatch(TranslationsChangedEvent(newLangCode: code));
    }

    return Center(
      child: Column(
        children: [
          RaisedButton(
            onPressed: _onLoginButtonPressed,
            child: Text(allTranslations.text('signin')),
          ),
          RaisedButton(
            onPressed: _onVisitButtonPressed,
            child: Text(allTranslations.text('guest_signin')),
          ),
          RaisedButton(
            onPressed: () => _onChangeLanguagePressed('es'),
            child: Text(allTranslations.text('es')),
          ),
          RaisedButton(
            onPressed: () => _onChangeLanguagePressed('ca'),
            child: Text(allTranslations.text('ca')),
          ),
          RaisedButton(
            onPressed: () => _onChangeLanguagePressed('en'),
            child: Text(allTranslations.text('en')),
          ),
        ],
      ),
    );
  }
}
