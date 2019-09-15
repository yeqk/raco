import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class TranslationsEvent extends Equatable {
  TranslationsEvent([List props = const []]) : super(props);
}

class TranslationsChangedEvent extends TranslationsEvent {
  final String newLangCode;

  TranslationsChangedEvent({@required this.newLangCode}) : super([newLangCode]);
  @override
  String toString() =>
      'TranslationsChangedEvent';
}

