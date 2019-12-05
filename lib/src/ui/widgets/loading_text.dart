import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/blocs/loading_text/loading_text.dart';
import 'package:raco/src/resources/global_translations.dart';

class LoadingText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingTextBloc, LoadingTextState>(
      bloc: BlocProvider.of<LoadingTextBloc>(context),
      builder: (context, state) {
        if (state is LoadTextState) {
          return Text(state.text, style: TextStyle(color: Colors.white), overflow: TextOverflow.visible,);
        }
        return Text(allTranslations.text('default_loading'), style: TextStyle(color: Colors.white),overflow: TextOverflow.visible,);
      },
    );
  }
}
