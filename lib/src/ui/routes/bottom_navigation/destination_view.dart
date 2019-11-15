import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/blocs/drawer_menu/drawer_bloc.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/ui/routes/bottom_navigation/destination.dart';
import 'package:raco/src/ui/routes/bottom_navigation/schedule.dart';
import 'package:raco/src/ui/routes/drawer_menu/drawer_menu.dart';

class DestinationView extends StatefulWidget {
  const DestinationView({ Key key, this.destination }) : super(key: key);

  final Destination destination;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _translationBloc = BlocProvider.of<DrawerMenuBloc>(context);

    _onDrawerIconPressed() {
      _translationBloc.dispatch(DrawerIconPressedEvent());
    }

    return Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: Icon(Icons.home),
          onPressed: () => _onDrawerIconPressed(),
        ),
        title: Text(allTranslations.text('home')),
        backgroundColor: widget.destination.color,
        centerTitle: true,
      ),
      backgroundColor: widget.destination.color[100],
      body: _buildBody(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildBody() {
    if (widget.destination.index == 0) { //schedule
      return Schedule();
    } else if (widget.destination.index == 1) { //notes
      return Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: RaisedButton(),
      );
    } else if (widget.destination.index == 2) { //events
      return Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: RaisedButton(),
      );
    } else if (widget.destination.index == 3) { //news
      return Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: RaisedButton(),
      );
    } else {
      return null;
    }
  }
}