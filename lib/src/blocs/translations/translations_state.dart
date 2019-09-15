import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class TranslationsState extends Equatable {
  TranslationsState([List props = const []]) : super(props);
}

class TranslationsChangedState extends TranslationsState {
  final Locale newLocale;

  TranslationsChangedState({@required this.newLocale}) : super([newLocale]);

  @override
  String toString() => 'LoginInitial';
}
