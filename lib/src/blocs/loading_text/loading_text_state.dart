import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoadingTextState extends Equatable {
  LoadingTextState([List props = const []]) : super(props);
}

class LoadTextState extends LoadingTextState {
  final String text;

  LoadTextState({@required this.text}) : super([text]);
  @override
  String toString() => 'LoadTextState';
}