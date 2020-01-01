import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LabsState extends Equatable {
  LabsState([List props = const []]) : super(props);
}

class LabsInitState extends LabsState {

  @override
  String toString() => 'LabsInitState';
}

class UpdateLabsSuccessfullyState extends LabsState {

  @override
  String toString() => 'UpdateLabsSuccessfullyState';
}

class UpdateLabsErrorState extends LabsState {
  @override
  String toString() => 'UpdateLabsErrorState';
}

class UpdateLabsTooFrequentlyState extends LabsState {
  @override
  String toString() => 'UpdateLabsTooFrequentlyState';
}