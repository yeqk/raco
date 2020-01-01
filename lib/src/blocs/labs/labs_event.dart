import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LabsEvent extends Equatable {
  LabsEvent([List props = const []]) : super(props);
}

class LabsInitEvent extends LabsEvent {

  LabsInitEvent();
  @override
  String toString() =>
      'LabsInitEvent';
}


class LabsChangedEvent extends LabsEvent {

  LabsChangedEvent();
  @override
  String toString() =>
      'LabsChangedEvent';
}
