import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceRequest.dart';
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
              return ResourceDetailScreen(settings.arguments as Resources);
            case ResourceScreen.routeName:
              return ResourceScreen();
            case RequestFormScreen.routeName:
              return RequestFormScreen(
                  resource: settings.arguments as Resources);
          }
        });
  }
}
