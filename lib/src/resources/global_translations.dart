import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:raco/src/resources/user_repository.dart';

const List<String> _kSupportedLanguages  = ["en", "es", "ca"];
const _kDefaultLanguage  = "en";

class GlobalTranslations {
  Locale _locale;
  Map<String, dynamic> _localizadValues;

  //Singleton
  GlobalTranslations._internal();
  static final GlobalTranslations _translations = GlobalTranslations._internal();
  factory GlobalTranslations() {
    return _translations;
  }

  //Returns the list of supported locales
  Iterable<Locale> supportedLocales() => _kSupportedLanguages.map<Locale>((lang) => Locale(lang, ''));

  //Return the translation that corresponds to the key
  String text(String key){
    String string = '$key not found';

    if (_localizadValues != null) {
      String value = _localizadValues[key];
      if (value != null && value is String) {
        string = value;
      }
    }
    return string;
  }

  String get currentLanguage => _locale == null ? '' : _locale.languageCode;
  Locale get locale =>  _locale;

  Future<Null> init() async {
    if (_locale == null) {
      await setNewLanguage();
    }
    return null;
  }

  Future<Null> setNewLanguage([String newLanguage]) async {
    String language = newLanguage;
    if (language == null) {
      language = await  user.getPreferredLanguage();
      print('aui');
    }

    if (language == '') {
      String currentLocale = Platform.localeName.toLowerCase();
      if (currentLocale.length > 2){
        if (currentLocale[2] == "-" || currentLocale[2] == "_"){
          language = currentLocale.substring(0, 2);
        }
      }
    }

    if (!_kSupportedLanguages.contains(language)){
      language = _kDefaultLanguage;
    }

    _locale = Locale(language, '');

    String jsonContent = await rootBundle.loadString('assets/locale/locale_${_locale.languageCode}.json');
    _localizadValues = json.decode(jsonContent);

    return null;
  }

}

GlobalTranslations allTranslations = GlobalTranslations();