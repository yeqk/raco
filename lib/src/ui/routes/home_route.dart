import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/blocs/drawer_menu/drawer_bloc.dart';
import 'package:raco/src/ui/routes/bottom_navigation/destination.dart';
import 'package:raco/src/ui/routes/bottom_navigation/destination_view.dart';
import 'package:raco/src/ui/routes/drawer_menu/drawer_menu.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with TickerProviderStateMixin<HomeRoute> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) {
        return DrawerMenuBloc();
      },
      child: BlocBuilder<DrawerMenuBloc, DrawerMenuState>(
        builder: (context, state) {
          final _translationBloc = BlocProvider.of<DrawerMenuBloc>(context);
          if (state is DrawerMenuPressedState) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _scaffoldKey.currentState.openDrawer();
              _translationBloc.dispatch(DrawerIconNotPressedEvent());
            });
          }
          return Scaffold(
            key: _scaffoldKey,
            drawer: new DrawerMenu(),
            body: SafeArea(
              top: false,
              child: IndexedStack(
                index: _currentIndex,
                children: allDestinations.map<Widget>((Destination destination) {
                  return DestinationView(destination: destination);
                }).toList(),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: allDestinations.map((Destination destination) {
                return BottomNavigationBarItem(
                    icon: Icon(destination.icon),
                    backgroundColor: destination.color,
                    title: Text(destination.title)
                );
              }).toList(),
            ),
          );
        },
      ),
    );

  }
}