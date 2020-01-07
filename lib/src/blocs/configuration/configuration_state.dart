import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ConfigurationState extends Equatable {
  ConfigurationState([List props = const []]) : super(props);
}

class ConfigurationInitState extends ConfigurationState {

  @override
  String toString() => 'ConfigurationInitState';
}

class PrimaryColorChangedState extends ConfigurationState {
  @override
  String toString() => 'PrimaryColorChangedState';
}

class SecondaryColorChangedState extends ConfigurationState {
  @override
  String toString() => 'SecondaryColorChangedState';
}

class SubjectColorChangedState extends ConfigurationState {
  @override
  String toString() => 'SubjectColorChangedState';
}

class UpdateOptionsChangedState extends ConfigurationState {
  @override
  String toString() => 'UpdateOptionsChangedState';
}


