import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoadingTextEvent extends Equatable {
  LoadingTextEvent([List props = const []]) : super(props);
}

class LoadTextEvent extends LoadingTextEvent {
  final String text;

  LoadTextEvent({@required this.text}) : super([text]);
  @override
  String toString() =>
      'LoadTextEvent';
}
