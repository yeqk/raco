import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class NoticesState extends Equatable {
  NoticesState([List props = const []]) : super(props);
}

class NoticesInitState extends NoticesState {

  @override
  String toString() => 'NoticesInitState';
}

class UpdateNoticesSuccessfullyState extends NoticesState {

  @override
  String toString() => 'UpdateNoticesSuccessfullyState';
}

class UpdateNoticesErrorState extends NoticesState {
  @override
  String toString() => 'UpdateNoticesErrorState';
}

class UpdateNoticesTooFrequentlyState extends NoticesState {
  @override
  String toString() => 'UpdateNoticesTooFrequentlyState';
}