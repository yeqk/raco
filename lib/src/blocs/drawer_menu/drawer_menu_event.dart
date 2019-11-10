import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DrawerMenuEvent extends Equatable {
  DrawerMenuEvent([List props = const []]) : super(props);
}

class DrawerIconPressedEvent extends DrawerMenuEvent {
  @override
  String toString() =>
      'DrawerButtonPressedEvent';
}

class DrawerIconNotPressedEvent extends DrawerMenuEvent {
  @override
  String toString() =>
      'DrawerIconNotPressedEvent';
}