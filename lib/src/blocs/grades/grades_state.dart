import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class GradesState extends Equatable {
  GradesState([List props = const []]) : super(props);
}

class GradesInitState extends GradesState {

  @override
  String toString() => 'GradesInitState';
}

class GradeDeletedState extends GradesState {
  @override
  String toString() => 'GradeDeletedState';
}

class GradeEditedState extends GradesState {
  @override
  String toString() => 'GradeEditedState';
}

class GradeAddedState extends GradesState {
  @override
  String toString() => 'GradeAddedState';
}

