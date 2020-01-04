import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
        return RefreshConfiguration(
          headerBuilder: () =>
              WaterDropHeader(), // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
          footerBuilder: () =>
              ClassicFooter(), // Configure default bottom indicator
          headerTriggerDistance:
              80.0, // header trigger refresh trigger distance
          springDescription: SpringDescription(
              stiffness: 170,
              damping: 16,
              mass:
                  1.9), // custom spring back animate,the props meaning see the flutter api
          maxOverScrollExtent:
              100, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
          maxUnderScrollExtent: 0, // Maximum dragging range at the bottom
          enableScrollWhenRefreshCompleted:
              true, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
          enableLoadingWhenFailed:
              true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
          hideFooterWhenNotFull:
              false, // Disable pull-up to load more functionality when Viewport is less than one screen
          enableBallisticLoad:
              true, // trigger load more by BallisticScrollActivity
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "El Racó",
            theme: ThemeData(
              primaryColor: AppColors().primary,
              accentColor: AppColors().accentColor,
            ),
            locale: newLocale ?? allTranslations.locale,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
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
                return MissingRoute();
              },
            ),
          ),
        );
      },
    );
  }
}
