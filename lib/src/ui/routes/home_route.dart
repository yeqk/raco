import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raco/src/blocs/drawer_menu/drawer_bloc.dart';
import 'package:raco/src/resources/global_translations.dart';
import 'package:raco/src/ui/routes/bottom_navigation/destination.dart';
import 'package:raco/src/ui/routes/bottom_navigation/destination_view.dart';
import 'package:raco/src/ui/routes/drawer_menu/drawer_menu.dart';
import 'package:raco/src/utils/app_colors.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with TickerProviderStateMixin<HomeRoute> {
  List<Key> _destinationKeys;
  List<AnimationController> _faders;
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    _faders = allDestinations.map<AnimationController>((Destination destination) {
      return AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    }).toList();
    _faders[_currentIndex].value = 1.0;
    _destinationKeys = List<Key>.generate(allDestinations.length, (int index) => GlobalKey()).toList();
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders)
      controller.dispose();
    super.dispose();
  }

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
              child: Stack(
                fit: StackFit.expand,
                children: allDestinations.map((Destination destination) {
                  final Widget view = FadeTransition(
                    opacity: _faders[destination.index].drive(CurveTween(curve: Curves.fastOutSlowIn)),
                    child: KeyedSubtree(
                      key: _destinationKeys[destination.index],
                      child: DestinationView(
                        destination: destination,
                      ),
                    ),
                  );
                  if (destination.index == _currentIndex) {
                    _faders[destination.index].forward();
                    return view;
                  } else {
                    _faders[destination.index].reverse();
                    if (_faders[destination.index].isAnimating) {
                      return IgnorePointer(child: view);
                    }
                    return Offstage(child: view);
                  }
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
                    backgroundColor: AppColors().primary,
                    title: Text(allTranslations.text(destination.title))
                );
              }).toList(),
            ),
          );
        },
      ),
    );

  }
}