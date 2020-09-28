import 'package:flutter/material.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_screen.dart';

class ResourceNavigator extends StatefulWidget {
  @override
  _ResourceNavigatorState createState() => _ResourceNavigatorState();
}

GlobalKey<NavigatorState> resourceNavigatorKey = GlobalKey<NavigatorState>();

class _ResourceNavigatorState extends State<ResourceNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(key: resourceNavigatorKey, onGenerateRoute: generateRoute);
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          switch (settings.name) {
            case '/':
              return ResourceScreen();
            case ResourceDetailScreen.routeName:
              return ResourceDetailScreen();
            case ResourceScreen.routeName:
              return ResourceScreen();
          }
        });
  }
}