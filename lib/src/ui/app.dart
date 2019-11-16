import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:raco/src/blocs/translations/translations.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/ui/routes/routes.dart';
import 'package:raco/src/utils/app_colors.dart';

class App extends StatelessWidget {

  App({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranslationsBloc, TranslationsState>(
      bloc: BlocProvider.of<TranslationsBloc>(context),
      builder: (context, state) {

        Locale newLocale;
        if (state is TranslationsChangedState) {
          newLocale = state.newLocale;
        }
        return MaterialApp(
          title: "El Racó",
          theme: ThemeData(
              primaryColor: AppColors.primary,
              accentColor: AppColors.accentColor,

          ),
          locale: newLocale ?? allTranslations.locale,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: allTranslations.supportedLocales(),
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            bloc: BlocProvider.of<AuthenticationBloc>(context),
            builder: (context, state) {
              if (state is AuthenticationUninitializedState) {
                return SplashRoute();
              }
              if (state is AuthenticationAuthenticatedState) {
                return HomeRoute();
              }
              if (state is AuthenticationUnauthenticatedState) {
                return LoginRoute();
              }
              if (state is AuthenticationLoadingState) {
                return LoadingRoute();
              }

              if (state is AuthenticationVisitorLoggedState) {
                return VisitorHomeRoute();
              }
              return MissingRoute();
            },
          ),
        );
      },
    );
  }

}
