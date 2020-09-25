import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/follow/follow_overview.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/user/account-settings/change_password.dart';
import 'package:matchub_mobile/screens/user/edit-individual/edit_profile_individual.dart';
import 'package:matchub_mobile/screens/user/edit-organisation/edit_profile_organisation.dart';
import 'package:matchub_mobile/screens/user/user_screen.dart';

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
                projectId: settings.arguments as int,
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
