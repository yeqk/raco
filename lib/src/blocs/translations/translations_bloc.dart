import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/blocs/translations/translations.dart';
import 'package:raco/src/repositories/user_repository.dart';



class TranslationsBloc extends Bloc<TranslationsEvent, TranslationsState> {

  TranslationsState get initialState => TranslationsChangedState(newLocale: allTranslations.locale);

  @override
  Stream<TranslationsState> mapEventToState(TranslationsEvent event) async* {

    if (event is TranslationsChangedEvent) {
      await user.setPreferredLanguage(event.newLangCode);
      await allTranslations.setNewLanguage(event.newLangCode);
      Locale locale = Locale(event.newLangCode, '');
      yield TranslationsChangedState(newLocale: locale);
    }
  }
}
