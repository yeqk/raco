import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/blocs/loading_text/loading_text.dart';
import 'package:raco/src/blocs/news/news.dart';
import 'package:raco/src/blocs/translations/translations.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/resources/user_repository.dart';
import 'package:raco/src/ui/app.dart';
import 'package:raco/src/blocs/authentication/authentication.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raco/src/utils/app_colors.dart';



class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  bool pc = await user.isPresentInPreferences('primary_color');
  if (pc) {
    AppColors().primary = Color(int.parse(await user.readFromPreferences('primary_color')));
  }
  bool sc = await user.isPresentInPreferences('secondary_color');
  if (sc) {
    AppColors().accentColor = Color(int.parse(await user.readFromPreferences('secondary_color')));
  }

  await allTranslations.init();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<LoadingTextBloc>(
        builder: (context) {
          return LoadingTextBloc();
        },
      ),
      BlocProvider<AuthenticationBloc>(
        builder: (context) {
          return AuthenticationBloc(
            loadingTextBloc: BlocProvider.of<LoadingTextBloc>(context),
          )..dispatch(AppStartedEvent());
        },
      ),
      BlocProvider<TranslationsBloc>(
        builder: (context) {
          return TranslationsBloc();
        },
      ),
      BlocProvider<NewsBloc>(
        builder: (context) {
          return NewsBloc();
        },
      ),
    ],

    child: App(),
  ));
}
