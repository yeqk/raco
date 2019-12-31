import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  NewsEvent([List props = const []]) : super(props);
}

class UpdateNewsEvent extends NewsEvent {

  @override
  String toString() =>
      'UpdateNewsEvent';
}