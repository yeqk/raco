import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DrawerMenuState extends Equatable {
  DrawerMenuState([List props = const []]) : super(props);
}

class DrawerMenuNotPressedState extends DrawerMenuState {
  @override
  String toString() => 'DrawerMenuNotPressedState';
}

class DrawerMenuPressedState extends DrawerMenuState {
  @override
  String toString() => 'DrawerMenuPressedState';
}
