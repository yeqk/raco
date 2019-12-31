import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  NewsEvent([List props = const []]) : super(props);
}

class NewsInitEvent extends NewsEvent {

  NewsInitEvent();
  @override
  String toString() =>
      'NewsInitEvent';
}


class NewsChangedEvent extends NewsEvent {

  NewsChangedEvent();
  @override
  String toString() =>
      'NewsChangedEvent';
}
