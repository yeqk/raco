import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class NewsState extends Equatable {
  NewsState([List props = const []]) : super(props);
}

class NewsInitState extends NewsState {

  @override
  String toString() => 'NewsInitState';
}

class UpdateNewsSuccessfullyState extends NewsState {

  @override
  String toString() => 'UpdateNewsSuccessfullyState';
}

class UpdateNewsErrorState extends NewsState {
  @override
  String toString() => 'UpdateNewsErrorState';
}

class UpdateNewsTooFrequentlyState extends NewsState {
  @override
  String toString() => 'UpdateNewsTooFrequentlyState';
}