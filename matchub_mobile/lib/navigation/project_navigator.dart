import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/project_management/project_management.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';

class ProjectNavigator extends StatefulWidget {
  @override
  _ProjectNavigatorState createState() => _ProjectNavigatorState();
}

class _ProjectNavigatorState extends State<ProjectNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: generateRoute
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          switch (settings.name) {
            case ProjectDetailScreen.routeName:
              return ProjectDetailScreen(
                projectId: settings.arguments as int,
              );
            case ProjectManagementOverview.routeName:
              return ProjectManagementOverview(settings.arguments as Project);
          }
        });
  }
}
