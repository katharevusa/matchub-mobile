import 'package:flutter/material.dart';
import 'package:matchub_mobile/screens/chat/chat_screen.dart';
import 'package:matchub_mobile/screens/explore/explore_screen.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';

class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();

class _HomeNavigatorState extends State<HomeNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(key: homeNavigatorKey, onGenerateRoute: generateRoute);
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          switch (settings.name) {
            case '/':
              return ChatScreen();
            case ProjectDetailScreen.routeName:
              return ProjectDetailScreen(
                projectId: settings.arguments as int,
              );
          }
        });
  }
}
