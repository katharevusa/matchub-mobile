import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/follow/followOverview.dart';
import 'package:matchub_mobile/screens/profile/profileScreen.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/user/account_settings/change_password.dart';
import 'package:matchub_mobile/screens/user/edit_individual/editProfileIndividual.dart';
import 'package:matchub_mobile/screens/user/edit_organisation/editProfileOrganisation.dart';
import 'package:matchub_mobile/screens/user/userScreen.dart';

class ProfileNavigator extends StatefulWidget {
  @override
  _ProfileNavigatorState createState() => _ProfileNavigatorState();
}

GlobalKey<NavigatorState> profileNavigatorKey = GlobalKey<NavigatorState>();

class _ProfileNavigatorState extends State<ProfileNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(key: profileNavigatorKey, onGenerateRoute: generateRoute);
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          switch (settings.name) {
            case '/':
              return UserScreen();
            case ProfileScreen.routeName:
              return ProfileScreen(
                accountId: settings.arguments as int,
              );
            case FollowOverviewScreen.routeName:
              final user = (settings.arguments
                  as Map<String, dynamic>)['profile'] as Profile;
              final initialTab = (settings.arguments
                  as Map<String, dynamic>)['initialTab'] as int;
              return FollowOverviewScreen(user: user, initialTab: initialTab);
            case ProjectDetailScreen.routeName:
              return ProjectDetailScreen(
                project: settings.arguments as Project,
              );
            case EditIndividualScreen.routeName:
              return EditIndividualScreen(
                  profile: settings.arguments as Profile);
            case EditOrganisationScreen.routeName:
              return EditOrganisationScreen(
                  profile: settings.arguments as Profile);
            case ChangePasswordScreen.routeName:
              return ChangePasswordScreen();
          }
        });
  }
}
