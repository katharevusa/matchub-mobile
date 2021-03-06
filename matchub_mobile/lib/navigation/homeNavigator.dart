import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/chat/chatScreen.dart';
import 'package:matchub_mobile/screens/home/competition/competitionDetail.dart';
import 'package:matchub_mobile/screens/home/competition/joinCompetition.dart';
import 'package:matchub_mobile/screens/home/homeScreen.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/search/searchPage.dart';

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
        maintainState: false,
        settings: settings,
        builder: (BuildContext context) {
          switch (settings.name) {
            case '/':
              return HomeScreen();
            case SearchResults.routeName:
              return SearchResults();
            case ProjectDetailScreen.routeName:
              return ProjectDetailScreen(
                project: settings.arguments as Project,
              );
            case CompetitionDetail.routeName:
              return CompetitionDetail(
                competition: settings.arguments as Competition,
              );
            case JoinCompetition.routeName:
              return JoinCompetition(
                competition: settings.arguments as Competition,
              );
          }
        });
  }
}
