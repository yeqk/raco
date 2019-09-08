import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/ui/routes/routes.dart';
import 'package:raco/src/ui/widgets/loading_indocator.dart';

class App extends StatelessWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitializedState) {
            return SplashRoute();
          }
          if (state is AuthenticationAuthenticatedState) {
            return HomeRoute();
          }
          if (state is AuthenticationUnauthenticatedState) {
            return LoginRoute(userRepository: userRepository);
          }
          if (state is AuthenticationLoadingState) {
            return LoadingIndicator();
          }

          if (state is AuthenticationVisitorLoggedState) {
            return VisitorHomeRoute();
          }
          return MissingRoute();
        },
      ),
    );
  }
}