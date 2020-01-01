import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class NoticesEvent extends Equatable {
  NoticesEvent([List props = const []]) : super(props);
}

class NoticesInitEvent extends NoticesEvent {

  NoticesInitEvent();
  @override
  String toString() =>
      'NoticesInitEvent';
}


class NoticesChangedEvent extends NoticesEvent {

  NoticesChangedEvent();
  @override
  String toString() =>
      'NoticesChangedEvent';
}
