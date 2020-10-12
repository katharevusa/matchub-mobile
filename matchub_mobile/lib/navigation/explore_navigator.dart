import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/chat/chat_screen.dart';
import 'package:matchub_mobile/screens/explore/explore_screen.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';

class ExploreNavigator extends StatefulWidget {
  @override
  _ExploreNavigatorState createState() => _ExploreNavigatorState();
}

GlobalKey<NavigatorState> exploreNavigatorKey = GlobalKey<NavigatorState>();

class _ExploreNavigatorState extends State<ExploreNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(key: exploreNavigatorKey, onGenerateRoute: generateRoute);
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
                project: settings.arguments as Project,
              );
          }
        });
  }
}
