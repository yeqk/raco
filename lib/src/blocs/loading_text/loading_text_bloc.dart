import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:raco/src/blocs/loading_text/loading_text.dart';
import 'package:raco/src/resources/global_translations.dart';


class LoadingTextBloc extends Bloc<LoadingTextEvent, LoadingTextState> {

  LoadingTextState get initialState => LoadTextState(text: allTranslations.text('default_loading'));

  @override
  Stream<LoadingTextState> mapEventToState(LoadingTextEvent event) async* {
    if (event is LoadTextEvent) {
      yield LoadTextState(text: event.text);
    }
  }
}