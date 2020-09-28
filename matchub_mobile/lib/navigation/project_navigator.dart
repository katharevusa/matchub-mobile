import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/project/project_overview.dart';
import 'package:matchub_mobile/screens/project_management/project_management.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/screens/user/edit-individual/edit_profile_individual.dart';

class ProjectNavigator extends StatefulWidget {
  @override
  _ProjectNavigatorState createState() => _ProjectNavigatorState();
}

GlobalKey<NavigatorState> projectNavigatorKey = GlobalKey<NavigatorState>();

class _ProjectNavigatorState extends State<ProjectNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(key: projectNavigatorKey, onGenerateRoute: generateRoute);
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
            case '/':
              return ProjectOverview();
            case EditIndividualScreen.routeName:
              return EditIndividualScreen(
                  profile: settings.arguments as Profile);
          }
        });
  }
}

class BookNavigator extends StatefulWidget {
  int index;
  BookNavigator(this.index);
  @override
  _BookNavigatorState createState() => _BookNavigatorState();
}

GlobalKey<NavigatorState> bookNavigatorKey1 = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> bookNavigatorKey2 = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> bookNavigatorKey3 = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> bookNavigatorKey4 = GlobalKey<NavigatorState>();

class _BookNavigatorState extends State<BookNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.index == 1
          ? bookNavigatorKey1
          : widget.index == 2
              ? bookNavigatorKey2
              : widget.index == 3
                  ? bookNavigatorKey3
                  : bookNavigatorKey4,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return Books1();
                case '/books2':
                  return Books2();
              }
            });
      },
    );
  }
}

class Books1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: Text("Books 1"),
        ),
        FlatButton(
          child: Text("Go to books 2"),
          onPressed: () => Navigator.pushNamed(context, '/books2'),
        ),
      ],
    );
  }
}

class Books2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: Text("Books 2"),
        )
      ],
    );
  }
}